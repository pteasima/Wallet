//
//  TodosViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 05/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Corridor

protocol TodosContext {
    typealias State = AppState
    typealias Action = AppAction
    var state: I<State> { get }
    var dispatch: (Action) -> () { get }
}

struct DefaultTodosContext: TodosContext {
    var state: I<TodosContext.State> { return driver.state }
    var dispatch: (TodosContext.Action) -> () { return driver.dispatch }

    private let driver: Driver<TodosContext.State, TodosContext.Action> = Driver(state: {var s = AppState(); s.todos.append(Todo(name: "test", createdAt: Date())); return s}(), reduce: { print("another reducer");print($0, $1) })
}

private extension HasContext {
    typealias Context = TodosContext
    static var `default`: Resolver<Self, TodosContext> {
        return Resolver(context: DefaultTodosContext())
    }
}
private extension HasInstanceContext where Self.Context == TodosContext {
    var state: I<TodosContext.State> { return resolve[\.state] }
    var dispatch: (TodosContext.Action) -> () { return resolve[\.dispatch] }
}

final class TodosViewController: UITableViewController, IncrementalObject, HasInstanceContext {
    typealias Context = TodosContext
    var resolve = `default`

    var disposables: [AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //state[\.todos] wont typecheck, think its because [Todo] is not really Equatable, wait for conditional conformances
        observe(state.map { $0.todos }) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.value.todos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodosCell", for: indexPath)
        let model = state.value.todos[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = "\(model.createdAt)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dispatch(.selectTodo(atIndex: indexPath.row))
    }
}
