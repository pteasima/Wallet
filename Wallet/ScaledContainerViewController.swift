//
//  ScaledContainerView.swift
//  Wallet
//
//  Created by Petr Šíma on 03/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

// todo pass size instead of depending on keyWindow
// todo the parent collectionView complains about zero cell size inferred from constraints (we're not using any), should we care?

class ScaledContainerViewController: UIViewController {
    var child: UIViewController? {
        willSet {
            child?.willMove(toParentViewController: nil)
            child?.view.removeFromSuperview()
            child?.removeFromParentViewController()
        }
        didSet {
            guard let child = child else { return }
            addChildViewController(child)
            view.addSubview(child.view)
            child.didMove(toParentViewController: self)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let childView = child?.view else { return}
        childView.center = CGPoint(x: view.bounds.origin.x + view.bounds.size.width / 2, y: view.bounds.origin.y + view.bounds.size.height / 2)
        childView.bounds = UIApplication.shared.keyWindow?.bounds ?? .zero
        childView.transform = CGAffineTransform(scaleX: view.bounds.width / childView.bounds.width, y: view.bounds.height / childView.bounds.height)
    }

}

func scaledContainer(child: I<IBox<UIViewController>>) -> IBox<UIViewController> {
    let vc = ScaledContainerViewController()
    let box = IBox(vc)
    box.disposables.append(child.observe { (child) in
        vc.child = child.unbox
        box.disposables.append(child) // todo remove old one
    })
    return box.map { $0 }
}
