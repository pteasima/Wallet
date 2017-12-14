//
//  AppContainerViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 09/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class AppContainerViewController: UIViewController {
    
    @IBOutlet weak var appContainer_: UIView!
    @IBOutlet weak var iphone_: UIImageView!


    var offset: CGFloat = 0 {
        didSet {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}

extension AppContainerViewController {
    var appContainer: UIView { return appContainer_ }
    var iphone: UIImageView { return iphone_ }
}
