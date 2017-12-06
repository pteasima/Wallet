//
//  Collection+Safe.swift
//  Wallet
//
//  Created by Petr Šíma on 05/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

extension Collection {
    public subscript(safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }

}
