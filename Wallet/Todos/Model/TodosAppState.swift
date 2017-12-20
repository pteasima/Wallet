//
//  AppState.swift
//  Wallet
//
//  Created by Petr Šíma on 05/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

struct TodosAppState: Equatable, Codable {
    var todos: [Todo]
    var selectedTodoIndex: Int?

    static func ==(lhs: TodosAppState, rhs: TodosAppState) -> Bool {
        return lhs.todos == rhs.todos && lhs.selectedTodoIndex == rhs.selectedTodoIndex
    }
}

struct Todo: Equatable, Codable {
    var name: String
    var createdAt: Date

    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return lhs.name == rhs.name && lhs.createdAt == rhs.createdAt
    }
}

extension TodosAppState {
    static var sample: TodosAppState {
        return TodosAppState(todos: [
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            Todo(name: "first todo", createdAt: Date()),
            Todo(name: "second todo", createdAt: Date()),
            ], selectedTodoIndex: nil)
    }
}

extension TodosAppState {
    var selectedTodo: Todo? {
        return selectedTodoIndex.flatMap { todos[safe: $0] }
    }
}
