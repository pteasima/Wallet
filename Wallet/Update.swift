//
//  Update.swift
//  Wallet
//
//  Created by Petr Šíma on 28/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

enum TimeTravelAction {
    case toggle
//    case enter
//    case seek(to: Int)
//    case select(Int)
}


enum AppAction {
    case go
    case back
    case goHome
    case goToEnd

}
enum Action {
    case timeTravel(TimeTravelAction)
    case app(AppAction)
}

let appReducer = Reducer<State, AppAction> { state, action in
    print(state, action)
    switch action {
    case .go:
        state.loginStep = state.loginStep + 1
    case .back:
        state.loginStep = state.loginStep - 1
    case .goHome:
        state.loginStep = 0
    case .goToEnd:
        state.loginStep = 2
    }
    print(state, action)
    print("------")
}

let timeTravelingReducer = Reducer<TimeTravelingState<State>, Action> { state, action in
    guard case let .timeTravel(a) = action else {
        //other action, save the state to pastStates
        state.pastStates = [state.liveState] + state.pastStates
        return
    }
    switch a {
    case .toggle: //acts as toggle for now
        switch state.viewMode {
        case .live: state.viewMode = .seeking
        case .seeking: state.viewMode = .cards
        case .cards: state.viewMode = .live
        }

    default: break
    }
}

let reducer: Reducer<TimeTravelingState, Action> =
//    Reducer { state, action in
//        print("justprechecking")
//        print(state)
//    }
//    <>

    timeTravelingReducer
            <>
    appReducer.lift(state: \.liveState, action: Action.prism.app)

//    <>
//    Reducer { state, action in
//        print("justchecking")
//        print(state)
//}

extension Action {
    enum prism {
        static let app = Prism<Action, AppAction>(
            preview: {
                if case let .app(action) = $0 { return action }
                return nil
        },
            review: Action.app
        )
        static let timeTravel = Prism<Action, TimeTravelAction>(
            preview: {
                if case let .timeTravel(action) = $0 { return action }
                return nil
        },
            review: Action.timeTravel
        )
    }
}


