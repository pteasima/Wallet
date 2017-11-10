//
//  ImageView.swift
//  Wallet
//
//  Created by Petr Šíma on 09/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit


func imageView(image: I<UIImage?>, subviews: [Subview] = [], isUserInteractionEnabled: I<Bool> = I(constant: false)) -> IBox<UIImageView> {
    let v = IBox(UIImageView())
    v.bind(image, to: \.image)
    subviews.forEach { (subview, constraints) in
        v.addSubview(subview, constraints: constraints)
    }
    v.bind(isUserInteractionEnabled, to: \.isUserInteractionEnabled)
    return v
}

