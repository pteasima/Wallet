//
//  Store.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class Store<S, A> where S: Equatable {
    private let reducer: Reducer<S, A>
    private var state: Input<S>


    init(reducer: Reducer<S, A>, initialState: S, view: (S, (A) -> Void ) -> IBox<UIViewController>) {
        self.reducer = reducer
        self.state = Input(initialState)
        self.rootViewController = view(initialState, dispatch)
        UIApplication.shared.keyWindow?.rootViewController = rootViewController.unbox
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }

    func dispatch(_ action: A) {
        self.state.change { state in
            self.reducer.reduce(&state, action)
        }
    }

    var rootViewController: IBox<UIViewController>!

}


