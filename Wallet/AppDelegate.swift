//
//  AppDelegate.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

struct State {
    typealias LoginStep = Int
    var loginStep: LoginStep = 0
    var previousLoginStep: LoginStep?
}
extension State: Equatable {
    static func ==(lhs: State, rhs: State) -> Bool {
        return lhs.loginStep == rhs.loginStep && lhs.previousLoginStep == rhs.previousLoginStep
    }
}
enum Action {
    case go
    case back
    case backTapped
}
func reduce(state: inout State, action: Action) {
    print(state, action)
    switch action {
    case .go:
        state.previousLoginStep = state.loginStep
        state.loginStep = state.loginStep + 1
    case .back:
        state.previousLoginStep = nil
        state.loginStep = state.loginStep - 1
    case .backTapped:
        state.previousLoginStep = state.loginStep
        state.loginStep = state.loginStep - 1
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var store: Store<State, Action>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.store = Store(reducer: Reducer(reduce: reduce), initialState: State(), view: { state, dispatch in
            return LoginFlow.vc(state, dispatch)
        })
        self.store?.run(in: self.window!)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

