//
//  IncrementalCocoa.swift
//  
//
//  Created by Petr Šíma on 28/11/2017.
//

import UIKit

private let disposablesKey = AssociationKey<[AnyObject]>(default: [])
extension NSObject: IncrementalExtensionsProvider {}
extension Incremental where Base: NSObject {
    mutating func bind<Value>(_ value: I<Value>, to keyPath: WritableKeyPath<Base, Value>) {
        weak var mutableBase = base
        observe(value) { mutableBase?[keyPath: keyPath] = $0 }
    }

    mutating func observe<Value>(_ value: I<Value>, observer: @escaping (Value) -> ()) {
        disposables.append(value.observe(observer))
    }

    private var disposables: [AnyObject] {
        get { return base.associations.value(forKey: disposablesKey) }
        set { base.associations.setValue(newValue, forKey: disposablesKey) }
    }

}
