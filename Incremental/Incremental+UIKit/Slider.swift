//
//  Slider.swift
//  Wallet
//
//  Created by Petr Šíma on 03/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

class Slider: UISlider {
    var onChange: (Float) -> Void = { _ in }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func valueChanged() {
        onChange(value)
    }
}

func slider(value: I<Float>, minValue: I<Float>, maxValue: I<Float>, hidden: I<Bool> = I(constant: false), onChange: @escaping (Float) -> Void ) -> IBox<UISlider> {
    let slider = Slider()
    let box = IBox(slider)
    box.bind(value, to: \.value)
    box.bind(minValue, to: \.minimumValue)
    box.bind(maxValue, to: \.maximumValue)
    box.bind(hidden, to: \.hidden)
    slider.onChange = onChange
    return box.map { $0 }
}
