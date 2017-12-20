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
    @IBOutlet weak var rightSegmentedControl_: UISegmentedControl!

    var onTap: (UITapGestureRecognizer) -> () = { _ in }
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        onTap(sender)
    }

}

extension UtilsViewController {
    var stateLabel: UILabel { return stateLabel_ }
    var scrollView: UIScrollView { return scrollView_ }
    var stateLabelBottom: NSLayoutConstraint { return stateLabelBottom_ }
    var rightSegmentedControl: UISegmentedControl { return rightSegmentedControl_ }
}
