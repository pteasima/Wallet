//
//  AppDelegate.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

// todo chris uses arrayWithHistory directly inside his state (but its a class, not data), is this safe?

func testView() -> IBox<UIViewController> {
    let layout = UICollectionViewFlowLayout()
    let items = ArrayWithHistory([UIColor.red, UIColor.green, UIColor.blue])
    let vc = collectionViewController(layout: I(constant: layout), items: items, createContent: { (color) -> ViewOrVC in
        // todo if we want reuse, we need to implement a view cache
        .view(label(text: I(constant: "test"), backgroundColor: I(constant: color)).cast)
    })
    return vc.map { $0 }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var store: Store<TimeTravelingState<State>, Action>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let state = TimeTravelingState<State>(liveState: State(), pastStates: [], viewMode: .live)
        self.store = Store<TimeTravelingState, Action>(reducer: reducer, initialState: state, view: { state, dispatch in
//            testView()
//            return LoginFlow.vc(state[\.liveState], dispatch)
            return TimeTravelManager.vc(state, dispatch)
        })
        self.store?.run(in: self.window!)

        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tap))
        let longPressRec = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        window?.addGestureRecognizer(tapRec)
        window?.addGestureRecognizer(longPressRec)
        return true
    }

    @objc func tap() {
        store?.dispatch(.app(.go))
    }
    @objc func longPress() {
        store?.dispatch(.timeTravel(.enter))
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

