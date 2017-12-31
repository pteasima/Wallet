//
//  HomeCheckInNavigationController.swift
//  Wallet
//
//  Created by Petr Šíma on 20/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Corridor

final class HomeNavigationController: UINavigationController, IncrementalObject, HomeContextAware {
    typealias Context = HomeContext
    var resolve = `default`
    
    var disposables: [AnyObject] = []
    
    weak var mainVC: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observe(state.map { $0.isCheckInCompleted }) { [weak self] in
            if $0 {
                let mainVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self?.pushViewController(mainVC, animated: true)
                self?.mainVC = mainVC
            } else {
                self?.popToRootViewController(animated: false)
            }
        }
    }
    
}


