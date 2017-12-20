//
//  TimeTravel.swift
//  Wallet
//
//  Created by Petr Šíma on 06/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Corridor


//protocol TimeTravelState: Equatable, Codable {
//    associatedtype AppStateType: Equatable, Codable
//    associatedtype AppActionType
//
//    var liveState: AppStateType { get set }
//    var pastStates: [AppStateType] { get set }
//    var viewMode: TimeTravelViewMode { get set }
//    var currentIndex: Int? { get set }
//}

enum TimeTravelViewMode: String, Codable {
    case live
    case seeking
//    case cards
}

struct DummyAppState: Equatable, Codable {
    static func ==(lhs: DummyAppState, rhs: DummyAppState) -> Bool {
        return true
    }
}

class AnyAppState: Equatable, Codable {
//    let rawType: Any.Type //probably dont really need this, I just saw it somewhere :D
    let eq: (AnyAppState) -> Bool
    let state: Any
    init<S>(_ state: S) where S: Equatable, S: Codable {
        self.state = state
//        rawType = S.self
        eq = { other in
            guard //S.self == other.rawType,
                let otherState = other.state as? S
                else { assertionFailure(); return false }
            return state == otherState
        }

    }
    static func ==(lhs: AnyAppState, rhs: AnyAppState) -> Bool {
        return lhs.eq(rhs)
    }
    required init(from decoder: Decoder) throws {
        fatalError()
    }
    func encode(to encoder: Encoder) throws {
        fatalError()
    }

}

enum TimeTravelNavSegment: String, Codable, Equatable {
    case action
    case swift
    case json
}

enum TimeTravel<S,A> where S: Codable, S: Equatable { }
extension TimeTravel {

    struct DispatchInfo: Codable, Equatable {
        let state: S
        let action: String
        let date: Date

        static func ==(lhs: DispatchInfo, rhs: DispatchInfo) -> Bool { return
            lhs.state == rhs.state && lhs.action == rhs.action && lhs.date == rhs.date
        }
    }


    struct State: Equatable, Codable {
        var liveState: S
        var history: [DispatchInfo]
        var viewMode: TimeTravelViewMode
        var selectedSegment: TimeTravelNavSegment
        var currentIndex: Int?

//        init(state: S) {
//            self.liveState = state
//        }

        var pastStates: [S] { return history.map { $0.state } }
        var allStates: [S] {
            return [liveState] + pastStates
        }
        var displayedFrame: DispatchInfo {
            guard let currentIndex = currentIndex else { return DispatchInfo(state: liveState, action: "noAction", date: Date())
            }
            return history[currentIndex]
        }
        var percent: Float { return 1.0 }

        static func ==(lhs: TimeTravel.State, rhs: TimeTravel.State) -> Bool { return
            lhs.allStates == rhs.allStates && lhs.viewMode == rhs.viewMode && lhs.currentIndex == rhs.currentIndex && lhs.selectedSegment == rhs.selectedSegment
        }
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
    case selectSegment(TimeTravelNavSegment)
    case seekBack
    case seekForward
//    case scrollToBottom //this action only changes UI state which I dont want to persist, I will try keeping this bit of logic in the vc itself. For science...
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
    static func reducer(appReducer: @escaping (inout S, A) -> Void) -> Reducer<State,Action> {
        return timeTravelReducer <> Reducer(reduce: appReducer).lift(state: \.liveState, action: TimeTravel.Action.prism.app)
    }
    static var timeTravelReducer : Reducer<State, Action> {
        return .init { state, action in
            guard case let .timeTravel(a) = action else {
                //other action, save the state to pastStates if not timetraveling, ignore otherwise
                if case .live = state.viewMode {
                    state.history = [DispatchInfo(state: state.liveState, action: String(describing: action), date: Date() /*coeffect, todo: start giving a fuck*/)] + state.history
                }
                return
            }
            switch a {
            case .toggle: //acts as toggle for now
                switch state.viewMode {
                case .live:
                    state.viewMode = .seeking
                    state.currentIndex = nil
                case .seeking:
                    state.viewMode = .live
                    state.currentIndex = nil
                }
//            case let .seek(toPercent: percent):
//                assert(state.viewMode == .seeking)
//                state.viewMode = .seeking
//                let total = state.pastStates.count + 1
//                let newIndex = Int(floor(percent * Float(total)))
//                if newIndex >= state.pastStates.count {
//                    state.currentIndex = nil
//                } else {
//                    state.currentIndex = newIndex
//                }
            case let .selectSegment(segment):
                if case .action = state.selectedSegment {
                    state.selectedSegment = .swift //todo remember last selected swift/json
                } else {
                    state.selectedSegment = segment
                }
            case .seekBack:
                if let index = state.currentIndex {
                    state.currentIndex = index - 1
                } else {
                    state.currentIndex = state.allStates.count - 1
                }
//                state.currentIndex = state.currentIndex.map { max(0, $0 - 1) } ?? state.allStates.count - 1
            case .seekForward:
                state.currentIndex = state.currentIndex.map { min(state.allStates.count - 1, $0 + 1) }
//            case .scrollToBottom:
//                break
            }
        }
    }
}

extension TimeTravel.State {
    //this is where I find out that the generic TimeTravel enum was a really bad idea. Todo refactor to have every part have its own generics instead of creating a generic namespace
    func map<NewState, DontCare>(transform: (S) -> NewState) -> TimeTravel<NewState, DontCare>.State {
        return .init(liveState: transform(liveState), history: history.map { TimeTravel<NewState, DontCare>.DispatchInfo(state:transform($0.state), action: $0.action, date: $0.date) }, viewMode: viewMode, selectedSegment: .swift, currentIndex: currentIndex)
    }
}

//extension TimeTravel {
//
//    static func view(appView: @escaping (I<S>, @escaping (A) -> Void) -> IBox<UIViewController>) -> ((I<State>, @escaping (Action) -> Void) -> UIViewController) {
//        return { state, dispatch in
//            //            let historySlider = slider(value: I(constant: 1), minValue: I(constant: 0), maxValue: I(constant: 1), hidden: state[\.viewMode].map { $0 != .seeking } , onChange: { dispatch(.timeTravel(.seek(toPercent: Double($0)))) })
//            //            let sliderWithConstraints: (IBox<UIView>, [Constraint]) =               (historySlider.cast, [equal(\.leadingAnchor, constant: I(constant: -10)), equal(\.trailingAnchor, constant: I(constant: 10)), equal(\.bottomAnchor, constant: I(constant: 100))
//            //                ])
//            //
//            ////            let toolbar = IBox(UIToolbar())
//            ////            let toolbarWithConstraints = (toolbar.cast, [equal(\.leadingAnchor), equal(\.trailingAnchor), equal(\.bottomAnchor)
//            ////                ])
//            ////
//            //            let layout: I<UICollectionViewLayout> = I(constant: LiveLayout())//state[\.viewMode].map { mode in
//            ////                switch mode {
//            ////                case .live: return LiveLayout()
//            ////                case .seeking: return SeekingLayout()
//            ////                case .cards: return UICollectionViewFlowLayout()
//            ////                }
//            ////            }
//            //            let displayedState = state[\.displayedState]
//            //            let pastStates: I<[S]> = state.map { $0.pastStates }
//            //            // todo I still hate this, seems way too fragile. We're sure that timetravel is append only, but same cant be said in general for similar usecases in actual apps (e.g. navigation stack), would love a find a general solution for these changing arrays, still feel like diffing will be necessary
//            //            let changes: I<IList<ArrayChange<I<S>>>> = pastStates.map { states in
//            //                guard let first = states.first else { return .empty }
//            //                let change = ArrayChange<I<S>>.insert(I(constant: first), at: 1)
//            //                return .cons(change, I(constant: .empty))
//            //            }
//            //            let items = ArrayWithHistory<I<S>>([displayedState] /*past states should begin empty*/, changes: changes)
//            //            // todo update slider from state?
//            //
//            //            let appDispatch = { dispatch(.app($0)) }
//            //
//            //
//            ////            let app = scaledContainer(child: I(constant: collectionViewController(layout: layout, items: items, createContent: { (state) -> ViewOrVC in
//            ////                if state === displayedState {
//            ////                    return .vc(appView(state, appDispatch))
//            ////                }else {
//            ////                    return .vc(scaledContainer(child: I(constant: appView(state, appDispatch))))
//            ////                    // todo make and store UI snapshots instead of rendering the whole thing?
//            ////                }
//            ////
//            ////            }).map { $0 }))
//            //
//            //
//            //
//            ////            let appWithConstraints = (,
//            ////                sizeToParent()
//            ////                )
//            ////
//            //
//            //
//            //            let iphoneX = imageView(image: I(constant: #imageLiteral(resourceName: "iphonex")))
//            //            let iphoneXWithConstaints = (iphoneX.cast, [
//            //                equal(\.centerXAnchor, 0),
//            //                equal(\.centerYAnchor, -10),
//            //                equalTo(constant: state[\.viewMode].map {
//            //                    switch $0 {
//            //                    case .live: return 485.51
//            //                    default: return 310
//            //                    }
//            //
//            //                }, \.widthAnchor),
//            //                equalTo(constant: state[\.viewMode].map {
//            //                    switch $0 {
//            //                    case .live: return 914.26
//            //                    default: return 590
//            //                    }
//            //                    }, \.heightAnchor, animation: { parent, child in
//            //                        UIView.animate(withDuration: 1, animations: {
//            //                            parent.layoutIfNeeded()
//            //                        }, completion: nil)
//            //
//            //
//            //                })
//            //                ])
//            //
//            //            let app =  collectionViewController(layout: layout, items: items, createContent: { (state) -> ViewOrVC in
//            //                if state === displayedState {
//            //                    return .vc(appView(state, appDispatch))
//            //                }else {
//            //                    return .vc(scaledContainer(child: I(constant: appView(state, appDispatch))))
//            //                    // todo make and store UI snapshots instead of rendering the whole thing?
//            //                }
//            //
//            //            }, subviews: [iphoneXWithConstaints]).map { $0 }
//            //
//            //            let scale : CGFloat = 0.65
//            //            let appConstraints =  [
//            //                equal(\.centerXAnchor),
//            //                equal(\.centerYAnchor,
//            //                                            constant: state[\.viewMode].map {
//            //                                            switch $0 {
//            //                                            case .live: return 0
//            //                                            default: return 80
//            //                                            }
//            //                    }),
//            //
//            //                equalTo(constant: state[\.viewMode].map {
//            //                                    switch $0 {
//            //                                    case .live: return UIScreen.main.bounds.width
//            //                                    default: return UIScreen.main.bounds.width * scale
//            //                                    }
//            //
//            //                    }, \.widthAnchor),
//            //
//            //
//            //                equalTo(constant: state[\.viewMode].map {
//            //                    switch $0 {
//            //                    case .live: return UIScreen.main.bounds.height
//            //                    default: return UIScreen.main.bounds.height * scale
//            //                    }
//            //                    }, \.heightAnchor),
//            //                ]
//            //
//            //            let rootView = Wallet.scrollView()
//            //            rootView.addSubview(sliderWithConstraints.0, constraints: sliderWithConstraints.1)
//            //
//            //            let vc = viewController(rootView: rootView, constraints: sizeToParent())
//            //
//            //
//            //            app.unbox.willMove(toParentViewController: vc.unbox)
//            //            rootView.addSubview(app.map { $0.view }, constraints: appConstraints)
//            //            vc.unbox.addChildViewController(app.unbox)
//            //
//            //
//
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
//            return vc
//        }
//    }
//
//}
//
//class LiveLayout: UICollectionViewLayout {
//    override var collectionViewContentSize: CGSize {
//        return collectionView?.bounds.size ?? .zero
//    }
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard indexPath.item == 0 else {
//            return UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        }
//        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        attr.frame = collectionView?.bounds ?? .zero
//        return attr
//    }
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return Array(0..<(collectionView?.numberOfSections ?? 0)).flatMap { s in
//            Array(0..<(collectionView?.numberOfItems(inSection: s) ?? 0)).flatMap { i in
//                return layoutAttributesForItem(at: IndexPath(item: i, section: s))
//            }
//        }
//    }
//}
//
//class SeekingLayout: UICollectionViewLayout {
//    override var collectionViewContentSize: CGSize {
//        return collectionView?.bounds.size ?? .zero
//    }
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard indexPath.item == 0 else {
//            return UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        }
//        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        attr.frame = collectionView?.bounds.insetBy(dx: 40, dy: 60) ?? .zero // todo scale the same in both directions
//        return attr
//    }
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return Array(0..<(collectionView?.numberOfSections ?? 0)).flatMap { s in
//            Array(0..<(collectionView?.numberOfItems(inSection: s) ?? 0)).flatMap { i in
//                return layoutAttributesForItem(at: IndexPath(item: i, section: s))
//            }
//        }
//    }
//}
//
//extension TimeTravelViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}

