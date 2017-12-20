//
//  HomeCheckInNavigationController.swift
//  Wallet
//
//  Created by Petr Šíma on 20/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Corridor

final class HomeCheckInNavigationController: UINavigationController, IncrementalObject, HomeContextAware {
    typealias Context = HomeContext
    var resolve = `default`
    
    var disposables: [AnyObject] = []
    
}


