//
//  TimeTravelViewControlelr.swift
//  Wallet
//
//  Created by Petr Šíma on 09/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import Corridor

protocol TimeTravelContext {
    typealias State = TimeTravel<AnyAppState, Any>.State
    typealias Action = TimeTravelAction
    var state: I<State> { get }
    var dispatch: (Action) -> () { get }
    var instantiateApp: () -> UIViewController { get }
}

struct DefaultTimeTravelContext: TimeTravelContext {
    var state: I<TimeTravelContext.State> { return I(constant: TimeTravel<AnyAppState,Any>.State(liveState: AnyAppState(DummyAppState()), pastStates: [], viewMode: .live, currentIndex: nil)) }
    var dispatch: (TimeTravelAction) -> () { return { print($0) } }
    var instantiateApp: () -> UIViewController { return { UIViewController() } }
    //    private let driver: Driver<TimeTravelContext.State, TimeTravelContext.Action> = Driver(state: .sample, reduce: { print("yet another reducer");print($0, $1) })
}

private extension HasContext {
    typealias Context = TimeTravelContext
    static var `default`: Resolver<Self, TimeTravelContext> {
        return Resolver(context: DefaultTimeTravelContext())
    }
}
private extension HasInstanceContext where Self.Context == TimeTravelContext {
    var state: I<TimeTravelContext.State> { return resolve[\.state] }
    var dispatch: (TimeTravelContext.Action) -> () { return resolve[\.dispatch] }
    var instantiateApp: () -> UIViewController {
        return resolve[\.instantiateApp]
    }
}
// we need a root container that wraps two child controllers to make both navbars behave. I chose to keep the children 100% dumb and just orchestrate everything from this controller. In practical iOS apps this sort of architecture shouldnt be needed, its just UIKit being UIKit in a rare scenario
final class TimeTravelViewController: UIViewController, IncrementalObject, HasInstanceContext, UIScrollViewDelegate {
    typealias Context = TimeTravelContext
    var resolve = `default`

    var disposables: [AnyObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()


        let appVC = instantiateApp()
        appContainerViewController.addChildViewController(appVC)
        appContainerViewController?.appContainer.addSubview(appVC.view)
        appContainerViewController?.appContainer.sendSubview(toBack: appVC.view)
        appVC.view.translatesAutoresizingMaskIntoConstraints = false
        appVC.view.topAnchor.constraint(equalTo: appContainerViewController.appContainer.topAnchor).isActive = true
        appVC.view.leftAnchor.constraint(equalTo: appContainerViewController.appContainer.leftAnchor).isActive = true
        appVC.view.bottomAnchor.constraint(equalTo: appContainerViewController.appContainer.bottomAnchor).isActive = true
        appVC.view.rightAnchor.constraint(equalTo: appContainerViewController.appContainer.rightAnchor).isActive = true
        appVC.didMove(toParentViewController: appContainerViewController)

        utilsViewController.scrollView.delegate = self


        let longPressRec = UILongPressGestureRecognizer { [weak self] in
            if case .began = $0.state {
                self?.dispatch(.toggle)
            }
        }
        view.addGestureRecognizer(longPressRec)

        let isTimeTravelClosed = state[\.viewMode].map { $0 == .live  }


        observe(isTimeTravelClosed) { [weak self] in
            //disable innteraction on the whole containerview, else it steals touches
            self?.appContainerViewController.view.superview?.isUserInteractionEnabled = $0
            if $0 {
                self?.utilsViewController.scrollView.scrollTo(direction: .bottom)
            } else {
                self?.utilsViewController.scrollView.setContentOffset(CGPoint(x: 0, y: self!.utilsViewController.scrollView.contentSize.height - self!.utilsViewController.scrollView.bounds.height - 500), animated: true)
            }
        }
        bind(isTimeTravelClosed.map { !$0 }, to: \.utilsViewController.scrollView.isScrollEnabled)


        bind(state[\.displayedState].map { "\($0.state)" }, to: \.utilsViewController.stateLabel.text)


        let actionSegmentedControl = UISegmentedControl(items: ["Action"])
        let leftItem = UIBarButtonItem(customView:  actionSegmentedControl)
        utilsViewController.navigationItem.leftBarButtonItem = leftItem
        actionSegmentedControl.addTarget(self, action: #selector(onActionSegmentSelected), for: .valueChanged)

        let titleLabel = UILabel()
        titleLabel.numberOfLines = 3
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = "ontrol.superview?.layer.borderWidth = 1. Solve the problem by expanding view so the"
        navigationItem.titleView = titleLabel
        //scrollViewDelegate is setup through storyboard, im trying to embace the life of a storyboarder.
        
        utilsViewController.stateLabelBottom.constant = UIScreen.main.bounds.height + 200


    }

    weak var appContainerViewController: AppContainerViewController!
    weak var utilsViewController: UtilsViewController!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AppContainerEmbed"?:
            appContainerViewController = segue.destination as? AppContainerViewController
        case "UtilsEmbed"?:
            utilsViewController = (segue.destination as? UINavigationController)?.topViewController as? UtilsViewController
            _ = utilsViewController.view
        default: break
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.appContainerViewController.view.transform = CGAffineTransform(translationX: 0, y: 270).scaledBy(x: 0.25, y: 0.25)
        self.appContainerViewController.view.layoutIfNeeded()
        appTransformAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn, animations: {
            self.appContainerViewController.view.transform = .identity
        })
        appTransformAnimator?.startAnimation()
        appTransformAnimator?.isReversed = false
        //todo animation breaks when app goes to background
        appTransformAnimator?.pauseAnimation()
        utilsViewController.scrollView.scrollTo(direction: .bottom)

    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate { onStop(scrollView) }
    }
    var appTransformAnimator: UIViewPropertyAnimator?

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        appTransformAnimator?.fractionComplete = 1 - ((scrollView.bottomOffset )  / UIScreen.main.bounds.height)


        print(scrollView.bottomOffset)
        let threshold: CGFloat = 360
        if scrollView.bottomOffset > threshold {
            scrollView.contentInset.bottom = -500
        } else {
            scrollView.contentInset.bottom = 0
        }
    }

    private func onStop(_ scrollView: UIScrollView) {
        if scrollView.bottomOffset < 0 {
            dispatch(.toggle)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onStop(scrollView)
    }

    @objc func onActionSegmentSelected(){

    }

}

enum ScrollDirection {
    case top
    case right
    case bottom
    case left

    func contentOffsetWith(scrollView: UIScrollView) -> CGPoint {
        var contentOffset = CGPoint.zero
        switch self {
        case .top:
            contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
        case .right:
            contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
        case .bottom:
            contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.adjustedContentInset.bottom)
        case .left:
            contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
        }
        return contentOffset
    }
}
extension UIScrollView {
    func scrollTo(direction: ScrollDirection, animated: Bool = true) {
        self.setContentOffset(direction.contentOffsetWith(scrollView: self), animated: animated)
    }
}
extension UIScrollView {
    var bottomOffset: CGFloat {
        return contentSize.height - contentOffset.y - bounds.height
    }
}

