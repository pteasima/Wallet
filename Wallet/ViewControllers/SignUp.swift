//
//  SignUpViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 04/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Closures
import Corridor

enum SignUp {}
extension SignUp {
    struct State: Equatable {
        var username: String
        static func ==(lhs: State, rhs: State) -> Bool {
            return lhs.username == rhs.username
        }
    }
    enum Action {
        case usernameChanged(String)
        case passwordChanged(String)
        case signUpButtonTapped
        case loginButtonTapped
    }
    static let reducer: Reducer<State, Action> = Reducer { state, action in
        switch action {
        case let .usernameChanged(newUsername):
            state.username = newUsername
//        case .signUpButtonTapped:
//            state.isLoggedIn = true
        default: break
        }
    }
}
protocol SignUpContext {
    var state: I<SignUp.State> { get }
    var dispatch: (SignUp.Action) -> () { get }
}
struct DefaultSignUpContext: SignUpContext {
    let state: I<SignUp.State> = I(constant: .init(username: "user"))
    let dispatch: (SignUp.Action) -> () = { print($0) }
}
extension HasContext {
    typealias Context = SignUpContext
    static var `default`: Resolver<Self, SignUpContext> {
        return Resolver(context: DefaultSignUpContext())
    }
}
extension HasInstanceContext where Self.Context == SignUpContext {
    var state: I<SignUp.State> { return resolve[\.state] }
    var dispatch: (SignUp.Action) -> () { return resolve[\.dispatch] }
}

final class SignUpViewController: UIViewController, IncrementalObject, HasInstanceContext {
    typealias Context = SignUpContext

    @IBOutlet weak var usernameTextField_: UITextField!
    @IBOutlet weak var passwordTextField_: UITextField!
    @IBOutlet weak var signUpButton_: UIButton!

    var disposables: [AnyObject] = []
    var resolve = `default`

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(state[\.username].map { Optional($0) }, to: \.usernameTextField.text)
        bind(state[\.username].map { Optional($0) }, to: \.passwordTextField.text)
        usernameTextField.onChange { [weak self] in self?.dispatch(.usernameChanged($0)) }
    }
}






















extension SignUpViewController {
    var usernameTextField: UITextField { return usernameTextField_ }
    var passwordTextField: UITextField { return passwordTextField_ }
    var signUpButton: UIButton { return signUpButton_ }
}


















//extension SignUp {
//    static func bind(state: I<State>, dispatch: @escaping (Action) -> (), to vc: SignUpViewController) {
//        vc.onViewDidLoad = { [unowned vc] in
//            vc.usernameTextField.onChange { dispatch(.usernameChanged($0)) }
//            vc.passwordTextField.onChange { dispatch(.passwordChanged($0)) }
//            vc.signUpButton.onTap { dispatch(.signUpButtonTapped) }
//            vc.bind(state[\.username].map { Optional($0) }, to: \.usernameTextField.text)
////            vc.observe(state[\.isLoggedIn]) { [unowned vc] in
////                if $0 {
////                    vc.performSegue(withIdentifier: "signUpToHome") { segue in
////                        guard let homeVC = segue.destination as? UIViewController else { fatalError() }
////                        print(homeVC)
////                    }
////                }
////            }
//        }
//    }
//}


