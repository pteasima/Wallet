//
//  Store.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class Store<S, A> where S: Equatable, S: Codable {
    private let reducer: Reducer<S, A>
    private var state: Input<S>
    private var disposables: [Any] = []
//    private var history: I<[S]> = I(constant: [])
    private var history: [S]

    init(reducer: Reducer<S, A>, initialState: S, view: (I<S>, @escaping (A) -> Void ) -> IBox<UIViewController>) {
        self.reducer = reducer
        self.state = Input(initialState)
        self.rootViewController = view(state.i, dispatch)

        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent("history.json")
        history = {
            let json = try? Data(contentsOf: url, options: [])
            return json.flatMap { try? JSONDecoder().decode([S].self, from: $0) } ?? []
        }()

        let encoder = JSONEncoder()
        disposables.append(state.i.observe { s in
            self.history.append(s)
            let json = try? encoder.encode(s)
            try? json?.write(to: url)
        })
    }

    func dispatch(_ action: A) {
        self.state.change { state in
            self.reducer.reduce(&state, action)
        }
    }
    private func timetravel(to index: Int) {
        self.state.write(history[index])
    }

    var rootViewController: IBox<UIViewController>!

}

extension Store {
    func run(in window: UIWindow) {
        window.rootViewController = rootViewController.unbox
        window.addTimetravelOverlay(for: self)
        window.makeKeyAndVisible()
    }
}
extension UIWindow {
    func addTimetravelOverlay(for store: Store<State, Action>) {

    }
}


