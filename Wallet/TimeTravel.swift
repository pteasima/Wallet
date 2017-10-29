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
        let layout: I<UICollectionViewLayout> = state[\.viewMode].map { mode in
            switch mode {
            case .live: return LiveLayout()
            case .cards: return UICollectionViewFlowLayout()
            }
        }
        let liveState = state[\.liveState]
        let pastStates: I<[State]> = state.map { $0.pastStates }
        let changes: I<IList<ArrayChange<I<State>>>> = pastStates.map { states in
            guard let first = states.first else { return .empty }
            let change = ArrayChange<I<State>>.insert(I(constant: first), at: 1)
            return .cons(change, I(constant: .empty))
        }
        let items = ArrayWithHistory<I<State>>([liveState] /*past states should begin empty*/, changes: changes)
        return collectionViewController(layout: layout, items: items, createContent: { (state) -> ViewOrVC in
            if state === liveState {
                return .vc(LoginFlow.vc(state, dispatch))
            }else {
                return .view(label(text: state[\.loginStep].map { String($0) }).cast)
            }

            //            LoginFlow.vc(state, dispatch)
        }).map { $0 }
    }

    class LiveLayout: UICollectionViewLayout {
        override var collectionViewContentSize: CGSize {
            return collectionView?.bounds.size ?? .zero
        }
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            guard indexPath.item == 0 else {
                return UICollectionViewLayoutAttributes(forCellWith: indexPath)
            }
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attr.frame = collectionView?.bounds ?? .zero
            return attr
        }
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            return Array(0..<(collectionView?.numberOfSections ?? 0)).flatMap { s in
                Array(0..<(collectionView?.numberOfItems(inSection: s) ?? 0)).flatMap { i in
                   return layoutAttributesForItem(at: IndexPath(item: i, section: s))
                }
            }
        }
    }
}

