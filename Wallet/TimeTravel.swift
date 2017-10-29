//
//  TimeTravel.swift
//  Wallet
//
//  Created by Petr Šíma on 29/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

enum TimeTravelManager {
    static func vc(_ state: I<TimeTravelingState<State>>, _ dispatch: @escaping (Action) -> Void) -> IBox<UIViewController> {
        let layout = UICollectionViewFlowLayout()
        let liveState = state[\.liveState]
        let pastStates: I<[State]> = state.map { $0.pastStates }
        let changes: I<IList<ArrayChange<I<State>>>> = pastStates.map { states in
            guard let first = states.first else { return .empty }
            let change = ArrayChange<I<State>>.insert(I(constant: first), at: 1)
            return .cons(change, I(constant: .empty))
        }
        let items = ArrayWithHistory<I<State>>([liveState] /*past states should begin empty*/, changes: changes)
        return collectionViewController(layout: I(constant: layout), items: items, createContent: { (state) -> IBox<UIView> in
            label(text: state[\.loginStep].map { String($0) }).cast
            //            LoginFlow.vc(state, dispatch)
        }).map { $0 }
    }
}
