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
protocol TodosNavigationContext: TodosContext {
    typealias State = AppState
    typealias Action = AppAction
    var state: I<State> { get }
    var dispatch: (Action) -> () { get }
}

struct DefaultTodosNavigationContext: TodosNavigationContext {
    var state: I<TodosNavigationContext.State> { return driver.state }
    var dispatch: (TodosNavigationContext.Action) -> () { return driver.dispatch }

    private let driver: Driver<TodosNavigationContext.State, TodosNavigationContext.Action> = Driver(state: .init(), reduce: appReducer.reduce)
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

//subclass all the things! I havent decided if we need flow coordinators or something like that. For now, the viewcontroller is the most important object in this architecture and navigation is generally handled in some parent viewcontroller. E.g. here, the TodosNavigationController acts as a "coordinator" for pushing the detail. The parent also need to pass its context to its childen, otherwise they will use their default context
final class TodosNavigationController: UINavigationController, HasInstanceContext {
    typealias Context = TodosNavigationContext
    var resolve = `default`

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let myContext = resolve.context
        _ = (topViewController as? TodosViewController).map { withContext($0, myContext) }
    }
}
