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
    }
}
extension TestApp.State: Equatable {
    static func ==(lhs: TestApp.State, rhs: TestApp.State) -> Bool {
        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b
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
    }
}

extension TestApp {
    enum Action {
        case changeColor
    }
}

extension TestApp {
    static let reducer: Reducer<TestApp.State, TestApp.Action> = Reducer { state, action in
        print(state, action)
        state.r = drand48() // this is a coeffect, but who cares
        state.g = drand48()
        state.b = drand48()
    }
}

extension TestApp {
    static func view(state: I<State>, dispatch: @escaping (TestApp.Action) -> Void) -> IBox<UIViewController> {
        let v = button(title: I(constant: ""), backgroundColor: state[\.color].map { $0 }, onTap: { dispatch(.changeColor) })
        return viewController(rootView: v, constraints: sizeToParent())
    }
}




