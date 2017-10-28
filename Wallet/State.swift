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

struct TimeTravelingState: Codable {
    enum CurrentState {
        case live(State)
        case past(State,Int)
    }
    var currentState: CurrentState {
        if let index = timeTravelIndex {
            return .past(allStates[index], index)
        }
        return .live(liveState)
    }
    var liveState: State {
        get {
            return self.liveState
        }
        set {
            pastStates.append(self.liveState)
            self.liveState = newValue
        }
    }
    var timeTravelIndex: Int? {
        get { return self.timeTravelIndex }
        set {
            guard let newValue = newValue, !pastStates.isEmpty else {
            self.timeTravelIndex = nil; return
            }
            self.timeTravelIndex = max(0,min(pastStates.count, newValue))
        }
    }
    internal private(set) var pastStates: [State] = []
    private var allStates: [State] {
        return pastStates + [liveState]
    }
}

