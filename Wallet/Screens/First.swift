//
//  ViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 27/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
//
//protocol Screen {
//    static func vc(_ state: I<State>,_ dispatch: @escaping (Action) -> Void) -> IBox<UIViewController>
//
//}

enum First {
    static func vc(_ state: I<State>,_ dispatch: @escaping (Action) -> Void) -> IBox<UIViewController> {
        return viewController(rootView:
            stackView(arrangedSubviews: [
                label(text: I(constant: "hello")).cast,
                textField(text: state.map { _ in "world" }, onChange: { _ in }).cast,
                button(title: I(constant: "go"), titleColor: I(constant: .black), onTap: { dispatch(.go) } ).cast,
                button(title: I(constant: "goToEnd"), titleColor: I(constant: .black), onTap: { dispatch(.goToEnd) } ).cast
                ]
            )
            , constraints: sizeToParent())
    }
}


enum Lifetime {
    case add(IBox<UIViewController>)
    case remove(IBox<UIViewController>?)
}
extension Lifetime: Equatable {
    static func ==(lhs: Lifetime, rhs: Lifetime) -> Bool {
        switch (lhs, rhs) {
        case let (.add(lvc), .add(rvc)): return lvc == rvc
        case let (.remove(lvc), .remove(rvc)): return lvc == rvc
        default: return false
        }
    }
}

enum Second {
    static func vc(_ state: I<State>,_ dispatch: @escaping (Action) -> Void) -> I<Lifetime> {
        let makeVC = { viewController(rootView:
            stackView(arrangedSubviews: [
                label(text: I(constant: "second")).cast,
                textField(text: state.map { _ in "world" }, onChange: { _ in }).cast,
                button(title: I(constant: "back"), titleColor: I(constant: .black), onTap: { dispatch(.go) } ).cast
                ]
            )
            , constraints: sizeToParent()) }
        var currentBox: IBox<UIViewController>? // todo get rid of this global sideeffect
        return state[\.loginStep].map { $0 >= 1 }.map { isPresented in
            if isPresented {
                let vc = makeVC()
                currentBox = vc
                return .add(vc)
            } else {
                let value = currentBox
                currentBox = nil // this is probably not needed, but just play it safe for now, this code will die anyway
                return .remove(value)
            }

        }
    }
}

enum Third {
    static func vc(_ state: I<State>,_ dispatch: @escaping (Action) -> Void) -> I<Lifetime> {
        let makeVC = { viewController(rootView:
            stackView(arrangedSubviews: [
                label(text: I(constant: "third")).cast,
                textField(text: state.map { _ in "world" }, onChange: { _ in }).cast,
                button(title: I(constant: "back"), titleColor: I(constant: .black), onTap: { dispatch(.goHome) } ).cast
                ]
            )
            , constraints: sizeToParent()) }
        var currentBox: IBox<UIViewController>? // todo get rid of this global sideeffect
        return state[\.loginStep].map { $0 >= 2 }.map { isPresented in
            if isPresented {
                let vc = makeVC()
                currentBox = vc
                return .add(vc)
            } else {
                let value = currentBox
                currentBox = nil // this is probably not needed, but just play it safe for now, this code will die anyway
                return .remove(value)
            }

        }
    }
}


enum LoginFlow {
    static func vc(_ state: I<State>,_ dispatch: @escaping (Action) -> Void) -> IBox<UIViewController> {
        let navStack = ArrayWithHistory([First.vc(state, dispatch)])
        let navC = navigationController(navStack) { dispatch(.back) }.cast
        let second: I<Lifetime> = Second.vc(state, dispatch)
        navC.disposables.append(second.observe { presentation in
            switch presentation {
            case let .add(secondVC):
                navStack.append(secondVC)
                let third: I<Lifetime> = Third.vc(state, dispatch)
                secondVC.disposables.append(third.observe { presentation in
                    switch presentation {
                    case let .add(thirdVC):
                        navStack.append(thirdVC)
                    case let .remove(thirdVC):
                        navStack.remove { $0 == thirdVC }
                    }
                })
            case let .remove(secondVC):
                navStack.remove { $0 == secondVC }
                secondVC?.disposables = [] // todo shouldnt this happen automatically somehow?
            }
        })

        //        navC.disposables.append(state.observe { s in
        //            switch (s.previousLoginStep, s.loginStep) {
        //            case (.none, _): break //initial
        //            case (.some(0),1):
        //                second = Second.vc(state, dispatch)
        //                navStack.append(second!)
        //            case (.some(1),0):
        //                navStack.remove(where: { $0 == second })
        //                second = nil
        //            default:
        //                fatalError("undefined transition")
        //            }
        //        })

        return navC
    }
}


