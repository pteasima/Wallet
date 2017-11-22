//
//  ScrollView.swift
//  Wallet
//
//  Created by Petr Šíma on 16/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {
    var onScroll: ((CGPoint) -> ())?
}

func scrollView(onScroll: ((CGPoint) -> ())? = nil) -> IBox<UIScrollView> {
    let scrollView = IBox(ScrollView())
    scrollView.unbox.onScroll = onScroll
    return scrollView.map { $0 }
}
