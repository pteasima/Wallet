//
//  TodoViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 05/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Corridor

protocol TodoContext {
    typealias State = AppState
    typealias Action = AppAction
    var state: I<State> { get }
    var dispatch: (Action) -> () { get }
}

struct DefaultTodoContext: TodoContext {
    var state: I<TodoContext.State> { return driver.state }
    var dispatch: (TodoContext.Action) -> () { return driver.dispatch }

    private let driver: Driver<TodoContext.State, TodoContext.Action> = Driver(state: .sample, reduce: { print("yet another reducer");print($0, $1) })
}

private extension HasContext {
    typealias Context = TodoContext
    static var `default`: Resolver<Self, TodoContext> {
        return Resolver(context: DefaultTodoContext())
    }
}
private extension HasInstanceContext where Self.Context == TodoContext {
    var state: I<TodoContext.State> { return resolve[\.state] }
    var dispatch: (TodoContext.Action) -> () { return resolve[\.dispatch] }
}

final class TodoViewController: UIViewController, IncrementalObject, HasInstanceContext {
    typealias Context = TodoContext
    var resolve = `default`

    var disposables: [AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(state[\.selectedTodo?.name], to: \.nameLabel.text)
        bind(state[\.selectedTodo?.createdAt].map { $0.map {"\($0)"} }, to: \.dateLabel.text)
    }


    @IBOutlet weak var nameLabel_: UILabel!
    @IBOutlet weak var dateLabel_: UILabel!
}

extension TodoViewController {
    var nameLabel: UILabel { return nameLabel_ }
    var dateLabel: UILabel { return dateLabel_ }
}
