//
//  AppState.swift
//  Wallet
//
//  Created by Petr Šíma on 05/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

struct AppState: Equatable, Codable {
    var todos: [Todo]
    var selectedTodoIndex: Int?

    static func ==(lhs: AppState, rhs: AppState) -> Bool {
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

extension AppState {
    static var sample: AppState {
        return AppState(todos: [
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

extension AppState {
    var selectedTodo: Todo? {
        return selectedTodoIndex.flatMap { todos[safe: $0] }
    }
}
