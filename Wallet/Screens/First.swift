//
//  ViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

enum First {
    static func vc(_ state: I<State>,_ dispatch: @escaping (Action) -> Void) -> IBox<UIViewController> {
        return viewController(rootView:
            stackView(arrangedSubviews: [
                label(text: I(constant: "hello")).cast,
                textField(text: state.map { _ in "world" }, onChange: { _ in }).cast,
                button(title: I(constant: "go"), titleColor: I(constant: .black), onTap: { dispatch(.go) } ).cast
                ]
            )
            , constraints: sizeToParent())
    }
}

enum Second {
    static func vc(_ state: I<State>,_ dispatch: @escaping (Action) -> Void) -> IBox<UIViewController> {
        return viewController(rootView:
            stackView(arrangedSubviews: [
                label(text: I(constant: "second")).cast,
                textField(text: state.map { _ in "world" }, onChange: { _ in }).cast,
                button(title: I(constant: "back"), titleColor: I(constant: .black), onTap: { dispatch(.back) } ).cast
                ]
            )
            , constraints: sizeToParent())
    }

}

enum LoginFlow {
    static func vc(_ state: I<State>,_ dispatch: @escaping (Action) -> Void) -> IBox<UIViewController> {
        let navStack = ArrayWithHistory([First.vc(state, dispatch)])
        let navC = navigationController(navStack) { dispatch(.back) }.cast
        var second: IBox<UIViewController>?
        navC.disposables.append(state.observe { s in
            switch (s.previousLoginStep, s.loginStep) {
            case (.none, _): break //no change needed (initial or UI pop)
            case (.some(0),1):
                second = Second.vc(state, dispatch)
                navStack.append(second!)
            case (.some(1),0):
                navStack.remove(where: { $0 == second })
                second = nil
            default:
                fatalError("undefined transition")
            }
        })

        return navC
    }
}


