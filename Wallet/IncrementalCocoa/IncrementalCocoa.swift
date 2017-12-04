//
//  IncrementalCocoa.swift
//  
//
//  Created by Petr Šíma on 28/11/2017.
//

import UIKit

protocol IncrementalObject: class {
    var disposables: [AnyObject] { get set }
}
extension IncrementalObject {
    func observe<Value>(_ value: I<Value>, observer: @escaping (Value) -> ()) {
        disposables.append(value.observe(observer))
    }
    func bind<Value>(_ value: I<Value>, to keyPath: WritableKeyPath<Self, Value>) {
        observe(value) { [weak self] in self?[keyPath: keyPath] = $0 }
    }
}

class IncrementalViewController: UIViewController, IncrementalObject {
    var disposables: [AnyObject] = []

    var onViewDidLoad: () -> () = { }

    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }

    private var segueHandler: (UIStoryboardSegue) -> () = { _ in }
    func performSegue(withIdentifier identifier: String, handler: @escaping (UIStoryboardSegue) -> ()) {
        segueHandler = handler
        performSegue(withIdentifier: identifier, sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segueHandler(segue)
    }
}
