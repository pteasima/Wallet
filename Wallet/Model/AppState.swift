//
//  AppState.swift
//  Wallet
//
//  Created by Petr Šíma on 05/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

struct AppState {
    var todos: [Todo] = []
}

struct Todo {
    var name: String
    var createdAt: Date
}
