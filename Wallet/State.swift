//
//  State.swift
//  Wallet
//
//  Created by Petr Šíma on 28/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation
struct State: Codable {
    typealias LoginStep = Int
    var loginStep: LoginStep = 0
}


extension State: Equatable {
    static func ==(lhs: State, rhs: State) -> Bool {
        return lhs.loginStep == rhs.loginStep
    }
}


//struct TimeTravelingState: Codable {
//    enum CurrentView {
//        case live
//        case seeking(Int)
//        case cards(Int)
//    }
//
//    var liveState: State {
//        get {
//            return self.liveState
//        }
//        set {
//            pastStates.append(self.liveState)
//            self.liveState = newValue
//            self.currentView = .live //there was a change to the actual live state, return to live view
//            // todo all this logic should be done in a reducer, this is just data.
//        }
//    }
//    var displayedState: State {
//        switch currentView {
//        case .live:
//            return liveState
//        case let .seeking(index):
//            return allStates[index]
//        case let .cards(index):
//            return allStates[index]
//        }
//    }
//    var currentView: CurrentView {
//        get { return self.currentView }
//        set {
//            guard !pastStates.isEmpty else { self.currentView = .live; return }
//            switch newValue {
//            case .live: self.currentView = newValue
//            case let .seeking(targetIndex):
//                self.currentView = .seeking(max(0,min(pastStates.count, targetIndex)))
//            case let .cards(targetIndex):
//                self.currentView = .cards(max(0,min(pastStates.count, targetIndex)))
//            }
//        }
//    }
//    internal private(set) var pastStates: [State] = []
//    var allStates: [State] {
//        return pastStates + [liveState]
//    }
//
//    init() {
//        self.liveState = State()
//        self.currentView = .live
//    }
//}
//
//extension TimeTravelingState: Equatable {
//    static func ==(lhs: TimeTravelingState, rhs: TimeTravelingState) -> Bool {
//        return lhs.allStates == rhs.allStates && lhs.currentView == rhs.currentView
//    }
//}
//extension TimeTravelingState.CurrentView: Equatable {
//    static func ==(lhs: TimeTravelingState.CurrentView, rhs: TimeTravelingState.CurrentView) -> Bool {
//        switch (lhs, rhs) {
//        case (.live,.live): return true
//        case let (.seeking(lhi), .seeking(rhi)): return lhi == rhi
//        case let (.cards(lhi), .cards(rhi)): return lhi == rhi
//        default: return false
//        }
//    }
//}
struct TimeTravelingState<S>: Codable where S: Codable, S: Equatable {
    var liveState: S
    var pastStates: [S]

    enum ViewMode: String, Codable {
        case live
        case cards
    }

    var viewMode: ViewMode
}
extension TimeTravelingState: Equatable {
    static func ==(lhs: TimeTravelingState, rhs: TimeTravelingState) -> Bool { return
        lhs.allStates == rhs.allStates && lhs.viewMode == rhs.viewMode
    }
}
//extension TimeTravelingState.ViewMode: Equatable {
//
//}
extension TimeTravelingState {
    var allStates: [S] {
        return [liveState] + pastStates
    }
}

