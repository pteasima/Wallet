//
//  LoginViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 22/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
//
//
//enum StoryboardError: Error {
//    case generic //dont care
//}
//protocol IncrementalViewController: class {
////    var bind: ((Self, inout [Any]) -> ())! { get set }
//    var disposables: [Any] { get set }
//
//}
//extension IncrementalViewController {
//
//    public static func instantiate<VC>(screen withIdentifier: String, ofType type: VC.Type, from storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil), bind: @escaping (VC) -> ()) throws -> VC where VC: IncrementalViewController, VC: UIViewController {
//        guard let vc = storyboard.instantiateViewController(withIdentifier: withIdentifier) as? VC else {
//            throw StoryboardError.generic
//        }
////        vc.bind = bind
//        _ = vc.view
//        bind(vc) // bind will setup bindings, add them to disposables array of the vc itself
//        return vc
//    }
//}

//struct DefaultContext: AppContext {
//    var storyboard: UIStoryboard {
//        return UIStoryboard(name: "Main", bundle: nil)
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
//extension HasInstanceContext where Self.Context == AppContext {
//    var storyboard: UIStoryboard {
//        return resolve[\.storyboard]
//    }
//}

final class LoginViewController:UIViewController/*, IncrementalViewController*/ {


//    typealias Context = AppContext

//    var resolve = `default`

    //    var bind: ((LoginViewController) -> ())!
    var disposables: [Any] = []

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


