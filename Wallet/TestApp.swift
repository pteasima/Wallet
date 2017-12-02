//
//  TestApp.swift
//  Wallet
//
//  Created by Petr Šíma on 04/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

enum TestApp { }

extension TestApp {
    struct State: Codable {
        var r: Double
        var g: Double
        var b: Double
        var someBool: Bool
    }
}
extension TestApp.State: Equatable {
    static func ==(lhs: TestApp.State, rhs: TestApp.State) -> Bool {
        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b
    }
}
extension TestApp.State {
    var color: UIColor {
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
    init() {
        r = drand48()
        g = drand48()
        b = drand48()
        someBool = true
    }
}

extension TestApp {
    enum Action {
        case changeColor
    }
}

extension TestApp {
    static let reducer: Reducer<TestApp.State, TestApp.Action> = Reducer { state, action in
        print(state, action)
        state.r = drand48() // this is a coeffect, but who cares
        state.g = drand48()
        state.b = drand48()
        state.someBool = !state.someBool
    }
}


extension TestApp {
    static func view(state: I<State>, dispatch: @escaping (TestApp.Action) -> Void) -> UIViewController {


        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! LoginViewController
        _ = vc.view

        weak var currentSubview: UIView?
        vc.i.observe(state[\.someBool]) { someBool in
            currentSubview?.removeFromSuperview()
            if someBool {
                let subview = UIView()
                subview.backgroundColor = .red
                subview.frame = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
                vc.view.addSubview(subview)
                currentSubview = subview
            }else {
                let subview = UIView()
                subview.backgroundColor = .green
                subview.frame = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
                vc.view.addSubview(subview)
                currentSubview = subview
            }
        }
        vc.i.bind(state[\.color].map { Optional($0)}, to: \.view.backgroundColor)

            return vc

    }
}

final class TextField: UITextField {
    var onInput: (String) -> () = { _ in }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEvents()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupEvents()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupEvents()
    }

    private func setupEvents() {
        addTarget(self, action: #selector(_onInput), for: .editingChanged)
    }

    @objc func _onInput() {
        onInput(text ?? "")
    }
}
//
//extension IBox where V: TextField {
//    // todo is it actually good to create functions with multiple params like this, given that we dont supply default values? This is a mutation of existing state and we may want to keep the values loaded from storyboard instead of overriding them with a I(constant:) binding. This isnt very functional but its not trying to be.
//    func bind(text: I<String>, textColor: I<UIColor>, onInput: @escaping (String) -> ()) { // todo on change could be <I> as well but do we need it? (same view to change the message its emitting during its lifetime)
//        bind(text, to: \.text)
//        bind(textColor, to: \.textColor)
//        unbox.onInput = onInput
//    }
//}
//
//extension IBox where V: NSObject {
//    public func child<Value>(_ keyPath: KeyPath<V, Value>) -> IBox<Value> where Value: AnyObject {
//        let child = unbox[keyPath: keyPath]
//        guard let childBox = self.disposables.first(where: { ($0 as? IBox<Value>)?.unbox === child }) as? IBox<Value> else { //swift doesnt have filterMap so fuck it just cast twice
//            let newBox = IBox<Value>(child)
//            disposables.append(newBox)
//            return newBox
//        }
//        return childBox
//    }
//
//
//}

