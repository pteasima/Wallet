//
//  RoutableNavigationController.swift
//  RoutableUIKit
//
//  Created by Lineholm, Henrik on 2017-08-18.
//  Copyright © 2017 RouteableUIKit. All rights reserved.
//

import UIKit


final class NavigationController: UINavigationController, UINavigationControllerDelegate {

    var onBack: () -> Void = { }

    private enum State { case idle, pushing, popping, unwinding }

    private var state: State = .idle


    // MARK: UIVC

    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    // MARK: UINavigationController

    open override var delegate: UINavigationControllerDelegate? {
        didSet {
            if (delegate !== self) {
                defaultDelegate = delegate
                delegate = oldValue
            }
        }
    }
    private var defaultDelegate: UINavigationControllerDelegate?

    open override func pushViewController(_ vc: UIViewController, animated: Bool) {
        state = .pushing
        super.pushViewController(vc, animated: animated)
    }
    open override func popViewController(animated: Bool) -> UIViewController? {
        if state != .unwinding { state = .popping }
        return super.popViewController(animated: animated)
    }
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if state != .unwinding { state = .popping }
        return super.popToRootViewController(animated: animated)
    }
    open override func popToViewController(_ vc: UIViewController, animated: Bool) -> [UIViewController]? {
        if state != .unwinding { state = .popping }
        return super.popToViewController(vc, animated: animated)
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        state = .unwinding
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }

    // MARK: UINavigationControllerDelegate

    open func navigationController(_ nc: UINavigationController, didShow vc: UIViewController, animated: Bool) {
        defaultDelegate?.navigationController?(nc, didShow: vc, animated: animated)

        if state == .popping {
            onBack()
        }

        state = .idle
    }
    open func navigationController(_ nc: UINavigationController, willShow vc: UIViewController, animated: Bool) {
        defaultDelegate?.navigationController?(nc, willShow: vc, animated: animated)
        if let tc = topViewController?.transitionCoordinator {
            tc.notifyWhenInteractionChanges({ [unowned self] (context) in
                if context.isCancelled {
                    self.state = .idle
                }
            })
        }
    }

}


