//
//  SignUpViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 04/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Closures

enum SignUp {}
extension SignUp {
    typealias State = TestApp.State
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
        case .signUpButtonTapped:
            state.isLoggedIn = true
        default: break
        }
    }
}

final class SignUpViewController: IncrementalViewController {
    @IBOutlet weak var usernameTextField_: UITextField!
    @IBOutlet weak var passwordTextField_: UITextField!
    @IBOutlet weak var signUpButton_: UIButton!
}
extension SignUpViewController {
    var usernameTextField: UITextField { return usernameTextField_ }
    var passwordTextField: UITextField { return passwordTextField_ }
    var signUpButton: UIButton { return signUpButton_ }
}

extension SignUp {
    static func bind(state: I<State>, dispatch: @escaping (Action) -> (), to vc: SignUpViewController) {
        vc.onViewDidLoad = { [unowned vc] in
            vc.usernameTextField.onChange { dispatch(.usernameChanged($0)) }
            vc.passwordTextField.onChange { dispatch(.passwordChanged($0)) }
            vc.signUpButton.onTap { dispatch(.signUpButtonTapped) }
            vc.bind(state[\.username].map { Optional($0) }, to: \.usernameTextField.text)
            vc.observe(state[\.isLoggedIn]) { [unowned vc] in
                if $0 { vc.performSegue(withIdentifier: "signUpToHome", sender: nil) }
            }
        }
    }
}


