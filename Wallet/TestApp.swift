//
//  TestApp.swift
//  Wallet
//
//  Created by Petr Šíma on 04/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

enum TestApp { }

extension TestApp {
    struct State: Codable {
        var r: Double
        var g: Double
        var b: Double
        var someBool: Bool
        var isLoggedIn: Bool
        var username: String
    }
}

extension TestApp.State {
    var route: Route {
        if isLoggedIn { return .login } else { return .home }
    }
    enum Route {
        case login
        case home
    }
}
extension TestApp.State: Equatable {
    static func ==(lhs: TestApp.State, rhs: TestApp.State) -> Bool {
        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.someBool == rhs.someBool && lhs.isLoggedIn == rhs.isLoggedIn && lhs.username == rhs.username
    }
}
extension TestApp.State {
    var color: UIColor {
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
    init() {
        r = drand48()
        g = drand48()
        b = drand48()
        someBool = true
        isLoggedIn = false
        username = ""
    }
}

extension TestApp {
    enum Action {
        case changeColor
        case login
        case logout
        case signUp(SignUp.Action)
    }
}

extension TestApp {
    static let reducer: Reducer<TestApp.State, TestApp.Action> = Reducer { state, action in
        print(action)
        switch action {
        case .changeColor:
            state.r = drand48() // this is a coeffect, but who cares
            state.g = drand48()
            state.b = drand48()
            state.someBool = !state.someBool
        case .login:
            assert(state.isLoggedIn == false) 
            state.isLoggedIn = true
        case .logout:
            assert(state.isLoggedIn == true)
            state.isLoggedIn = false
        default: break
        }
    } //<> SignUp.reducer.lift(action: TestApp.Action.prism.signUp)

}


extension TestApp {
    static func view(state: I<State>, dispatch: @escaping (TestApp.Action) -> ()) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navC = storyboard.instantiateInitialViewController() as! NavigationController
        navC.onBack = { dispatch(.logout) }
        let vc = navC.topViewController as! SignUpViewController
//        SignUp.bind(state: state, dispatch: { dispatch(.signUp($0)) }, to: vc)
        return navC

    }
}

extension TestApp.Action {
    enum prism {
        static var signUp : Prism<TestApp.Action, SignUp.Action> {
            return .init(
                preview: {
                    if case let .signUp(action) = $0 { return action }
                    return nil
            },
                review: TestApp.Action.signUp
            )
        }
    }
}
