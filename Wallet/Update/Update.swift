//
//  Update.swift
//  Wallet
//
//  Created by Petr Šíma on 05/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

enum AppAction {
    case selectTodo(atIndex: Int)
    case unselectTodo
}

let appReducer: Reducer<AppState, AppAction> = Reducer { state, action in
    switch action {
    case let .selectTodo(atIndex: index):
        state.selectedTodoIndex = index
    case let .unselectTodo:
        state.selectedTodoIndex = nil
    }
}
