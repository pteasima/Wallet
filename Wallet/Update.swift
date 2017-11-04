////
////  Update.swift
////  Wallet
////
////  Created by Petr Šíma on 28/10/2017.
////  Copyright © 2017 Petr Šíma. All rights reserved.
////
//
//import Foundation
//
//
//
//enum AppAction {
//    case go
//    case back
//    case goHome
//    case goToEnd
//
//}
//
//let appReducer = Reducer<State, AppAction> { state, action in
//    print(state, action)
//    switch action {
//    case .go:
//        state.loginStep = state.loginStep + 1
//    case .back:
//        state.loginStep = state.loginStep - 1
//    case .goHome:
//        state.loginStep = 0
//    case .goToEnd:
//        state.loginStep = 2
//    }
//    print(state, action)
//    print("------")
//}
//
//let reducer: Reducer<TimeTravelingState, Action> =
////    Reducer { state, action in
////        print("justprechecking")
////        print(state)
////    }
////    <>
//
//    timeTravelingReducer
//            <>
//    appReducer.lift(state: \.liveState, action: Action.prism.app)
//
////    <>
////    Reducer { state, action in
////        print("justchecking")
////        print(state)
////}
//
//
