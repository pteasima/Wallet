//
//  HomeAppState.swift
//  Wallet
//
//  Created by Petr Šíma on 20/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

struct HomeAppState: Equatable, Codable {
    static func ==(lhs: HomeAppState, rhs: HomeAppState) -> Bool {
        return true
    }
    static var sample: HomeAppState {
        return HomeAppState()
    }
}
