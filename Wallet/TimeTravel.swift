//
//  TimeTravel.swift
//  Wallet
//
//  Created by Petr Šíma on 29/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

// todo access control

enum TimeTravel<S,A> where S: Codable, S: Equatable { }

extension TimeTravel {
    struct State: Codable {
        var liveState: S
        var pastStates: [S] = []
        
        enum ViewMode: String, Codable {
            case live
            case seeking
            case cards
        }
        
        var viewMode: ViewMode = .live
        var currentIndex: Int? = nil // to prevent unreachable states, index should be an associated value on the .seeking ViewMode. However, this would make Codable conformance and other stuff more complicated, cba right now, maybe later
    }
}

extension TimeTravel.State: Equatable {
    static func ==(lhs: TimeTravel.State, rhs: TimeTravel.State) -> Bool { return
        lhs.allStates == rhs.allStates && lhs.viewMode == rhs.viewMode && lhs.currentIndex == rhs.currentIndex
    }
}
extension TimeTravel.State {
    init(state: S) {
        self.liveState = state
    }
    var allStates: [S] {
        return [liveState] + pastStates
    }
    var displayedState: S {
        guard let currentIndex = currentIndex else { return liveState }
        return pastStates[currentIndex]
    }
}

extension TimeTravel {
    
    enum Action {
        case timeTravel(TimeTravelAction)
        case app(A)
    }
}

enum TimeTravelAction {
    case toggle
    case seek(toPercent: Double)
    //    case enter
    //    case seek(to: Int)
    //    case select(Int)
}

extension TimeTravel.Action {
    enum prism {
        static var app : Prism<TimeTravel.Action, A> {
            return .init(
                preview: {
                    if case let .app(action) = $0 { return action }
                    return nil
            },
                review: TimeTravel.Action.app
            )
        }
        
        static var timeTravel : Prism<TimeTravel.Action, TimeTravelAction> {
            return .init(
                preview: {
                    if case let .timeTravel(action) = $0 { return action }
                    return nil
            },
                review: TimeTravel.Action.timeTravel
            )
        }
        
    }
}

extension TimeTravel {
    static func reducer(appUpdate: @escaping (inout S, A) -> Void) -> Reducer<State,Action> {
        return timeTravelReducer <> Reducer(reduce: appUpdate).lift(state: \.liveState, action: TimeTravel.Action.prism.app)
    }
    static var timeTravelReducer : Reducer<State, Action> {
        return .init { state, action in
            guard case let .timeTravel(a) = action else {
                //other action, save the state to pastStates
                state.pastStates = [state.liveState] + state.pastStates
                return
            }
            switch a {
            case .toggle: //acts as toggle for now
                switch state.viewMode {
                case .live:
                    state.viewMode = .seeking
                    state.currentIndex = nil
                case .seeking: state.viewMode = .cards
                case .cards:
                    state.viewMode = .live
                    state.currentIndex = nil
                }
            case let .seek(toPercent: percent):
                assert(state.viewMode == .seeking)
                state.viewMode = .seeking
                let total = state.pastStates.count + 1
                let newIndex = Int(floor(percent * Double(total)))
                if newIndex >= state.pastStates.count {
                    state.currentIndex = nil
                } else {
                    state.currentIndex = newIndex
                }
            default: break
            }
        }
    }
    
}

extension TimeTravel {
    
    static func view(appView: @escaping (I<S>, @escaping (A) -> Void) -> IBox<UIViewController>) -> ((I<State>, @escaping (Action) -> Void) -> IBox<UIViewController>) {
        return { state, dispatch in
            let historySlider = slider(value: I(constant: 1), minValue: I(constant: 0), maxValue: I(constant: 1), hidden: state[\.viewMode].map { $0 != .seeking } , onChange: { dispatch(.timeTravel(.seek(toPercent: Double($0)))) })
            let sliderWithConstraints: (IBox<UIView>, [Constraint]) =               (historySlider.cast, [equal(\.leadingAnchor, constant: I(constant: -10)), equal(\.trailingAnchor, constant: I(constant: 10)), equal(\.bottomAnchor, constant: I(constant: 100))
                ])
            
//            let toolbar = IBox(UIToolbar())
//            let toolbarWithConstraints = (toolbar.cast, [equal(\.leadingAnchor), equal(\.trailingAnchor), equal(\.bottomAnchor)
//                ])
//
            let layout: I<UICollectionViewLayout> = state[\.viewMode].map { mode in
                switch mode {
                case .live: return LiveLayout()
                case .seeking: return SeekingLayout()
                case .cards: return UICollectionViewFlowLayout()
                }
            }
            let displayedState = state[\.displayedState]
            let pastStates: I<[S]> = state.map { $0.pastStates }
            // todo I still hate this, seems way too fragile. We're sure that timetravel is append only, but same cant be said in general for similar usecases in actual apps (e.g. navigation stack), would love a find a general solution for these changing arrays, still feel like diffing will be necessary
            let changes: I<IList<ArrayChange<I<S>>>> = pastStates.map { states in
                guard let first = states.first else { return .empty }
                let change = ArrayChange<I<S>>.insert(I(constant: first), at: 1)
                return .cons(change, I(constant: .empty))
            }
            let items = ArrayWithHistory<I<S>>([displayedState] /*past states should begin empty*/, changes: changes)
            // todo update slider from state?
            
            let appDispatch = { dispatch(.app($0)) }
            
            
//            let app = scaledContainer(child: I(constant: collectionViewController(layout: layout, items: items, createContent: { (state) -> ViewOrVC in
//                if state === displayedState {
//                    return .vc(appView(state, appDispatch))
//                }else {
//                    return .vc(scaledContainer(child: I(constant: appView(state, appDispatch))))
//                    // todo make and store UI snapshots instead of rendering the whole thing?
//                }
//                
//            }).map { $0 }))
            
            
            
//            let appWithConstraints = (,
//                sizeToParent()
//                )
//
            
            
            let iphoneX = imageView(image: I(constant: #imageLiteral(resourceName: "iphonex")))
            let iphoneXWithConstaints = (iphoneX.cast, [
                equal(\.centerXAnchor, 0),
                equal(\.centerYAnchor, -10),
                equalTo(constant: state[\.viewMode].map {
                    switch $0 {
                    case .live: return 485.51
                    default: return 310
                    }

                }, \.widthAnchor),
                equalTo(constant: state[\.viewMode].map {
                    switch $0 {
                    case .live: return 914.26
                    default: return 590
                    }
                    }, \.heightAnchor)
                ])
            
            let app =  collectionViewController(layout: layout, items: items, createContent: { (state) -> ViewOrVC in
                if state === displayedState {
                    return .vc(appView(state, appDispatch))
                }else {
                    return .vc(scaledContainer(child: I(constant: appView(state, appDispatch))))
                    // todo make and store UI snapshots instead of rendering the whole thing?
                }
                
            }, subviews: [iphoneXWithConstaints]).map { $0 }
            
            let scale : CGFloat = 0.65
            let appConstraints =  [
                equal(\.centerXAnchor),
                equal(\.centerYAnchor,
                                            constant: state[\.viewMode].map {
                                            switch $0 {
                                            case .live: return 0
                                            default: return 80
                                            }
                                    }),
                
                equalTo(constant: state[\.viewMode].map {
                                    switch $0 {
                                    case .live: return UIScreen.main.bounds.width
                                    default: return UIScreen.main.bounds.width * scale
                                    }
                
                                }, \.widthAnchor),

                
                equalTo(constant: state[\.viewMode].map {
                    switch $0 {
                    case .live: return UIScreen.main.bounds.height
                    default: return UIScreen.main.bounds.height * scale
                    }
                    }, \.heightAnchor, animation: { parent, child in
                        UIView.animate(withDuration: 1, animations: {
                            parent.layoutIfNeeded()
                        })
                }),
                ]
            
            let rootView = Wallet.view(subviews: [sliderWithConstraints])
            let vc = viewController(rootView: rootView, constraints: sizeToParent())
            
            
            app.unbox.willMove(toParentViewController: vc.unbox)
            rootView.addSubview(app.map { $0.view }, constraints: appConstraints)
            vc.unbox.addChildViewController(app.unbox)
            
            
            
            return vc
        }
    }
    
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

