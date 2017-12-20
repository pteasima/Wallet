//
//  SingleSegmentControl.swift
//  Wallet
//
//  Created by Petr Šíma on 15/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class SingleSegmentControl: UISegmentedControl {
    override var selectedSegmentIndex: Int {
        get { return super.selectedSegmentIndex }
        set {
            if newValue != UISegmentedControlNoSegment, newValue == selectedSegmentIndex {
                self.selectedSegmentIndex = UISegmentedControlNoSegment
            }
            super.selectedSegmentIndex = newValue
        }
    }
}
