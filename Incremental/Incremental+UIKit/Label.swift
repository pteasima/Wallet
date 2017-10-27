//
//  Label.swift
//  Incremental
//
//  Created by Chris Eidhof on 27.09.17.
//  Copyright © 2017 objc.io. All rights reserved.
//

import UIKit

public func label(text: I<String>, backgroundColor: I<UIColor?> = I(constant: .clear), textColor: I<UIColor?> = I(constant: .black)) -> IBox<UILabel> {
    let result = IBox(UILabel(frame: .zero))
    result.bind(text, to: \.text)
    result.observe(value: textColor, onChange: { $0.textColor = $1 }) // doesn't work with bind because textColor is an IOU
    result.bind(backgroundColor, to: \.backgroundColor)
    return result
}


public func label(text: I<String>, backgroundColor: I<UIColor?> = I(constant: .clear), textColor: I<UIColor?> = I(constant: .black), font: I<UIFont>) -> IBox<UILabel> {
    let result = IBox(UILabel(frame: .zero))
    result.bind(text, to: \.text)
    result.observe(value: textColor, onChange: { $0.textColor = $1 }) // doesn't work with bind because textColor is an IOU
    result.bind(backgroundColor, to: \.backgroundColor)
    result.observe(value: font, onChange: { $0.font = $1 })
    return result
}
