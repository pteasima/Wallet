//
//  Store.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class Store<S, A> where S: Equatable, S: Codable {
    private let update: (inout S, A) -> Void
    private var state: Input<S>
//    private var disposables: [Any] = []
//    private var history: I<[S]> = I(constant: [])
//    private var history: [S]

    init(initialState: S, update: @escaping (inout S, A) -> Void, view: (I<S>, @escaping (A) -> Void ) -> IBox<UIViewController>) {
        self.update = update
        self.state = Input(initialState)
        self.rootViewController = view(state.i, dispatch)

//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let url = documents.appendingPathComponent("history.json")
//        history = {
//            let json = try? Data(contentsOf: url, options: [])
//            return json.flatMap { try? JSONDecoder().decode([S].self, from: $0) } ?? []
//        }()
//
//        let encoder = JSONEncoder()
//        disposables.append(state.i.observe { s in
//            self.history.append(s)
//            let json = try? encoder.encode(s)
//            try? json?.write(to: url)
//        })
    }

    func dispatch(_ action: A) {
        self.state.change { state in
            self.update(&state, action)
        }
    }

    var rootViewController: IBox<UIViewController>!

}

extension Store {
    func run(in window: UIWindow) {
        window.rootViewController = rootViewController.unbox
        window.makeKeyAndVisible()
    }
}
