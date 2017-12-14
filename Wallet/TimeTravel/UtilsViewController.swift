//
//  UtilsViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 09/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class UtilsViewController: UIViewController {
    @IBOutlet weak var stateLabelBottom_: NSLayoutConstraint!
    @IBOutlet weak var stateLabel_: UILabel!
    @IBOutlet weak var scrollView_: UIScrollView!
}

extension UtilsViewController {
    var stateLabel: UILabel { return stateLabel_ }
    var scrollView: UIScrollView { return scrollView_ }
    var stateLabelBottom: NSLayoutConstraint { return stateLabelBottom_ }
}
