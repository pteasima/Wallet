//
//  LoginViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 22/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var _usernameTextField: UITextField!
    @IBOutlet weak var _passwordTextField: UITextField!
    @IBOutlet weak var _stackViewCenter: NSLayoutConstraint!

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
}

extension LoginViewController { //workaround for swift keypaths bug https://bugs.swift.org/browse/SR-5551
    var usernameTextField: UITextField {
        return _usernameTextField!
    }
    var passwordTextField: UITextField {
        return _passwordTextField!
    }
    var stackViewCenter: NSLayoutConstraint {
        return _stackViewCenter!
    }
}


