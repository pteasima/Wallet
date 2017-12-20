//
//  HomeUpdate.swift
//  Wallet
//
//  Created by Petr Šíma on 20/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import Foundation

enum HomeAppAction {
    
}

let homeAppReducer = Reducer<HomeAppState, HomeAppAction> {
    print($0, $1)
}
