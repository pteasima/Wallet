//
//  IncrementalCocoa.swift
//  
//
//  Created by Petr Šíma on 28/11/2017.
//

import UIKit
let disposablesKey = AssociationKey<[AnyObject]>(default: [])
extension NSObject: IncrementalExtensionsProvider {}
extension Incremental where Base: UIViewController {
    var disposables: [AnyObject] {
        get { return base.associations.value(forKey: disposablesKey) }
        set { base.associations.setValue(newValue, forKey: disposablesKey) }
    }

}
