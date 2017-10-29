//
//  Optics.swift
//  Wallet
//
//  Created by Petr Šíma on 29/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

struct Prism<A, B> {
    let preview: (A) -> B?
    let review: (B) -> A
}
