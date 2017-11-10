//
//  View.swift
//  Wallet
//
//  Created by Petr Šíma on 09/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

typealias Subview = (IBox<UIView>, [Constraint])


func view(subviews: [Subview]) -> IBox<UIView> {
    let v = IBox(UIView())
    subviews.forEach { (subview, constraints) in
        v.addSubview(subview, constraints: constraints)
    }
    return v
}




