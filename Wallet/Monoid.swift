//
//  Monoid.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

precedencegroup MonoidAppend {
    associativity: left
}
infix operator <>
protocol Monoid {
    static var empty: Self { get }
    static func <> (lhs: Self, rhs: Self) -> Self
}
