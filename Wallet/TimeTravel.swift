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
            case .seeking: return SeekingLayout()
            case .cards: return UICollectionViewFlowLayout()
            }
        }
        let displayedState = state[\.displayedState]
        let pastStates: I<[State]> = state.map { $0.pastStates }
        let changes: I<IList<ArrayChange<I<State>>>> = pastStates.map { states in
            guard let first = states.first else { return .empty }
            let change = ArrayChange<I<State>>.insert(I(constant: first), at: 1)
            return .cons(change, I(constant: .empty))
        }
        let items = ArrayWithHistory<I<State>>([displayedState] /*past states should begin empty*/, changes: changes)
        let historySlider = slider(value: I(constant: 0), minValue: I(constant: 0), maxValue: I(constant: 1), hidden: state[\.viewMode].map { $0 != .seeking } , onChange: { dispatch(.timeTravel(.seek(toPercent: Double($0)))) })
        let sliderWithConstraints: IBox<(UIView, [Constraint])> = historySlider.map { ($0 as UIView, [equal(\.leadingAnchor),
                                                             equal(\.trailingAnchor),
                                                             equal(\.bottomAnchor)
            ])}



        let cv = collectionViewController(layout: layout, items: items, createContent: { (state) -> ViewOrVC in
            if state === displayedState {
                return .vc(scaledContainer(child: I(constant: LoginFlow.vc(state, dispatch))))
            }else {
                return .vc(scaledContainer(child: I(constant: LoginFlow.vc(state, dispatch))))
//                return .view(label(text: state[\.loginStep].map { String($0) }).cast) // todo UI snapshot
            }

        }, subviews: [sliderWithConstraints])
        return cv.map { $0 }
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

    class SeekingLayout: UICollectionViewLayout {
        override var collectionViewContentSize: CGSize {
            return collectionView?.bounds.size ?? .zero
        }
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            guard indexPath.item == 0 else {
                return UICollectionViewLayoutAttributes(forCellWith: indexPath)
            }
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attr.frame = collectionView?.bounds.insetBy(dx: 40, dy: 60) ?? .zero // todo scale the same in both directions
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

