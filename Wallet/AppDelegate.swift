//
//  AppDelegate.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Corridor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    typealias AppWithTimeTravel = TimeTravel<HomeAppState, HomeAppAction>

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        struct Context: TimeTravelContext {
            var state: I<TimeTravelContext.State> { return driver.state.map { $0.map { AnyAppState($0)} } }
            var dispatch: (TimeTravelContext.Action) -> () { return { self.driver.dispatch(.timeTravel($0)) } }

            struct AppContext: HomeContext {
                let state: I<HomeContext.State>
                let dispatch: (HomeContext.Action) -> ()
            }

            var instantiateApp: () -> UIViewController {
            return { let appVC = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeCheckInNavigationController
                return withContext(appVC, AppContext(state: self.driver.state[\.displayedFrame.state], dispatch: { self.driver.dispatch(.app($0)) }))
                }
            }
            let driver = Driver<AppWithTimeTravel.State, AppWithTimeTravel.Action>(state: .init(liveState: .sample, history: [], viewMode: .live, selectedSegment: .swift, currentIndex: nil), reduce: AppWithTimeTravel.reducer(appReducer: homeAppReducer.reduce).reduce)


        }
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = UIStoryboard(name: "TimeTravel", bundle: nil).instantiateInitialViewController() as! TimeTravelViewController
        _ = withContext(rootVC, Context())
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()

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

