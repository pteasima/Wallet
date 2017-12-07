//
//  TodosNavigationController.swift
//  Wallet
//
//  Created by Petr Šíma on 05/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Corridor

//if we need to create a reusable component with its own state and action, just create new types for them. Parent will be responsible to provide e.g. a mapping from its State to this State. But for simplicity, lets use AppState and AppAction while possible.
protocol TodosNavigationContext {
    typealias State = AppState
    typealias Action = AppAction
    var state: I<State> { get }
    var dispatch: (Action) -> () { get }
}

struct DefaultTodosNavigationContext: TodosNavigationContext {
    var state: I<TodosNavigationContext.State> { return driver.state }
    var dispatch: (TodosNavigationContext.Action) -> () { return driver.dispatch }

    private let driver: Driver<TodosNavigationContext.State, TodosNavigationContext.Action> = Driver(state: .sample, reduce: appReducer.reduce)
}

private extension HasContext {
    typealias Context = TodosNavigationContext
    static var `default`: Resolver<Self, TodosNavigationContext> {
        return Resolver(context: DefaultTodosNavigationContext())
    }
}
private extension HasInstanceContext where Self.Context == TodosNavigationContext {
    var state: I<TodosNavigationContext.State> { return resolve[\.state] }
    var dispatch: (TodosNavigationContext.Action) -> () { return resolve[\.dispatch] }
}

// Subclass ALL the things! I havent decided if we need flow coordinators or something like that. For now, the viewcontroller is the most important object in this architecture and navigation is generally handled in some parent viewcontroller. E.g. here, the TodosNavigationController acts as a "coordinator" for pushing the detail. The parent also needs to pass its context to its childen, otherwise they will use their default context
final class TodosNavigationController: NavigationController, IncrementalObject, HasInstanceContext {
    typealias Context = TodosNavigationContext
    var resolve = `default`

    var disposables: [AnyObject] = []

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }

    weak var listVC: TodosViewController?
    weak var detailVC: TodoViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let myContext = resolve.context

        struct Adapter: TodosContext {
            let context: TodosNavigationContext
            var state: I<TodosContext.State> { return context.state }
            var dispatch: (TodosContext.Action) -> () { return context.dispatch }
        }
        //  Im not yet sure how much value we can get from each controller having its own context type, so maybe we will use one context for the whole app (or just a few) which will get rid of the need for adapters.

        listVC = (topViewController as? TodosViewController).map { withContext($0, Adapter(context: myContext)) }

        // we maintain some local state to deal with navigation. If we have more than 2 controllers, we should still be able to figure out where we are and what we should do based on which of the above weak properties are nil/some. The idea is that while this may be error prone and not very nice, most apps are simple enough that this is doable. I havent seen navigation solved "properly" in any architecture, so at least with this approach we can start writting unidirectional apps today.

        onBack = { [weak self] in self?.dispatch(.unselectTodo) }
        observe(state[\.selectedTodoIndex]) { [weak self] index in
            let popIfNeeded = {
                if let _ = self?.detailVC,
                    let listVC = self?.listVC  {
                    _ = self?.popToViewController(listVC, animated: true)
                }
            }
            if let _ = index {
               popIfNeeded()
                self?.pushDetail()
            } else {
                popIfNeeded()
            }

        }
        //I was gonna support segues too, but if this is the architecture we end up going with, segues are just too much pain. Parent has to handle navigation anyway (all navigation changes must be done in response to state changes, else timetravel breaks). So triggering segues on children would just mean unnecessary communication which can go wrong (`child.onPrepareForSegue = { ... }`)
    }

    func pushDetail() {
        struct Adapter: TodoContext {
            let context: TodosNavigationContext
            var state: I<TodoContext.State> { return context.state }
            var dispatch: (TodoContext.Action) -> () { return context.dispatch }
        }
        guard let detailVC = (storyboard?.instantiateViewController(withIdentifier: "todoViewController") as? TodoViewController).map({ withContext($0, Adapter(context: resolve.context)) })
            else { return }
        pushViewController(detailVC, animated: true)
        self.detailVC = detailVC


    }
}
