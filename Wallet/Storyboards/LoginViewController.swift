//
//  LoginViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 22/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Corridor

//struct DefaultContext: AppContext {
//    var appStoryboard: UIStoryboard {
//        return UIStoryboard(name: "Main", bundle: nil)
//    }
//
//    struct Segue<VC: UIViewController> {
//        var destination: VC
//    }
//}
//
//extension HasContext {
//    typealias Context = AppContext
//
//    static var `default`: Resolver<Self, AppContext> {
//        return Resolver(context: DefaultContext())
//    }
//}
//
//extension HasStaticContext where Self.Context == AppContext {
//    static var appStoryboard: UIStoryboard {
//        return resolve[\.appStoryboard]
//    }
//}

final class LoginViewController:UIViewController/*, IncrementalViewController*/{
    typealias Context = AppContext

//    static var resolve = `default`

    //    var bind: ((LoginViewController) -> ())!
//    var disposables: [Any] = []

    @IBOutlet weak var _usernameTextField: UITextField!
    @IBOutlet weak var _passwordTextField: UITextField!
    @IBOutlet weak var _stackViewCenter: NSLayoutConstraint!

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(storyboard)
    }

    var onLogin: () -> () = { }
    @IBAction func login(_ sender: Any) {
        onLogin()
    }
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


