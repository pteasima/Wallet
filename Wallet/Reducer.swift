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

extension Reducer {
    func lift<T>(state: WritableKeyPath<T, S>) -> Reducer<T, A> {
        return Reducer<T, A> { t, a in
            self.reduce(&t[keyPath: state], a)
        }
    }
}

extension Reducer {
    func lift<B>(action: Prism<B, A>) -> Reducer<S, B> {
        return Reducer<S, B> { s, b in
            guard let a = action.preview(b) else { return }
            self.reduce(&s, a)
        }
    }
}

extension Reducer {
    func lift<T, B>(state: WritableKeyPath<T, S>, action: Prism<B, A>) -> Reducer<T, B> {
        return Reducer<T, B> { stateT, actionB in
            guard let actionA = action.preview(actionB) else { return }
            self.reduce(&stateT[keyPath: state], actionA)
        }
    }
}
