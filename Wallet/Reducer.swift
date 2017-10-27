//
//  Reducer.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

// typealias Reducer<S, A> = (S, A) -> S
struct Reducer<S, A> {
    let reduce: (inout S, A) -> Void
    // (A, B) -> (C, A)   ---> (inout A, B) -> C
    //
}

extension Reducer: Monoid {
    static var empty: Reducer<S, A> {
        return Reducer { s, _ in return }
    }

    // (S, A) -> S
    // (A, S) -> S
    // (A) -> (S) -> S
    // (A) -> Endo(S)
    static func <>(lhs: Reducer<S, A>, rhs: Reducer<S, A>) -> Reducer<S, A> {
        return Reducer { s, a in
            lhs.reduce(&s, a)
            rhs.reduce(&s, a)
        }
    }
}

