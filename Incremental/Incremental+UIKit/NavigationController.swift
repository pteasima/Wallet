//
//  NavigationController.swift
//  Incremental
//
//  Created by Chris Eidhof on 02.10.17.
//  Copyright © 2017 objc.io. All rights reserved.
//

import UIKit

public func barButtonItem(systemItem: UIBarButtonSystemItem, onTap: @escaping () -> ()) -> IBox<UIBarButtonItem> {
    let ta = TargetAction(onTap)
    let result = UIBarButtonItem(barButtonSystemItem: systemItem, target: ta, action: #selector(TargetAction.action(_:)))
    let box = IBox(result)
    box.disposables.append(ta)
    return box
}

private final class Delegate: RNCD {
    typealias Route = Any
    func routableNavigationController(_ rnc: RoutableNavigationController<Delegate>, didPush vc: UIVC, animated: Bool, sender: Any?) {
    }

    func routableNavigationController(_ rnc: RoutableNavigationController<Delegate>, didPop vc: UIVC, animated: Bool, sender: Any?) {
        onBack()
    }

    let onBack: () -> Void
    init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }
}

public func navigationController(_ viewControllers: ArrayWithHistory<IBox<UIViewController>>, onBack: @escaping () -> Void) -> IBox<UINavigationController> {
    let nc = RoutableNavigationController<Delegate>()
    nc.routingDelegate = Delegate(onBack: onBack)
    let result = IBox(nc as UINavigationController)
    result.bindViewControllers(to: viewControllers)
    return result
}

extension IBox where V: UINavigationController {
    func appendViewController(_ vc: IBox<UIViewController>) {
        self.unbox.viewControllers.append(vc.unbox)
        self.disposables.append(vc)
    }
    
    public func bindViewControllers(to value: ArrayWithHistory<IBox<UIViewController>>) {
        self.disposables.append(value.observe(current: { initialVCs in
            assert(self.unbox.viewControllers == [])
            for v in initialVCs {
                self.appendViewController(v)
            }
        }) { [unowned self] in
            switch $0 {
            case let .insert(v, at: i):
                if i == self.unbox.viewControllers.count {
                    self.unbox.pushViewController(v.unbox, animated: true)
                } else {
                    self.unbox.viewControllers.insert(v.unbox, at: i)
                }
                self.disposables.append(v)
            case .remove(at: let i):
                guard i < self.unbox.viewControllers.count else { return }//already popped, just catching up
                let v: UIViewController = self.unbox.viewControllers[i]
                let index = self.disposables.index { d in
                    if let vcBox = d as? IBox<UIViewController>, vcBox.unbox === v {
                        return true
                    }
                    return false
                }
                self.disposables.remove(at: index!)
                self.unbox.viewControllers.remove(at: i)
            case .replace(let with, let i):
                let v: UIViewController = self.unbox.viewControllers[i]
                let index = self.disposables.index { d in
                    if let vcBox = d as? IBox<UIViewController>, vcBox.unbox === v {
                        return true
                    }
                    return false
                }
                self.disposables.remove(at: index!)
                self.unbox.viewControllers[i] = with.unbox
                self.disposables.append(with)
            case let .move(at: from, to: to):
                self.unbox.viewControllers.swapAt(from, to)
            }
        })
    }

    public var cast: IBox<UIViewController> {
        return map { $0 }
    }
}

