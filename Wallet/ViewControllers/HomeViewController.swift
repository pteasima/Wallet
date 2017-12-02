//
//  HomeViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 02/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var onLogout: () -> () = { }
    @IBAction func logout(_ sender: Any) {
        onLogout()
    }
}
