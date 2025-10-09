//
//  SJSideMenuTransition.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 10/9/25.
//

import UIKit

// MARK: - SJSideMenuPresentationController

final class SJSideMenuPresentationController: UIPresentationController {

    private let dimmingView = UIView()
    private let menuWidth: CGFloat

    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         menuWidth: CGFloat = UIScreen.main.bounds.width * 0.8) {
        self.menuWidth = menuWidth
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        setupDimmingView()
    }

    private func setupDimmingView() {
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmingView.alpha = 0

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDimmingViewTap))
        dimmingView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleDimmingViewTap() {
        presentedViewController.dismiss(animated: true)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0,
                      y: 0,
                      width: menuWidth,
                      height: containerView.bounds.height)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 0
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let containerView = containerView else { return }

        dimmingView.frame = containerView.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

// MARK: - SJSideMenuAnimator

final class SJSideMenuAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let isPresenting: Bool
    private let duration: TimeInterval

    init(isPresenting: Bool, duration: TimeInterval = 0.5) {
        self.isPresenting = isPresenting
        self.duration = duration
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(using: transitionContext)
        } else {
            animateDismissal(using: transitionContext)
        }
    }

    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)

        toView.frame = finalFrame.offsetBy(dx: -finalFrame.width, dy: 0)
        containerView.addSubview(toView)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                toView.frame = finalFrame
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
            }
        )
    }

    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        let finalFrame = fromView.frame.offsetBy(dx: -fromView.frame.width, dy: 0)

        UIView.animate(
            withDuration: duration * 0.7,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                fromView.frame = finalFrame
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
            }
        )
    }
}

// MARK: - SJSideMenuTransitionDelegate

final class SJSideMenuTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    private let menuWidth: CGFloat

    init(menuWidth: CGFloat = UIScreen.main.bounds.width * 0.8) {
        self.menuWidth = menuWidth
        super.init()
    }

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return SJSideMenuPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            menuWidth: menuWidth
        )
    }

    func animationController(forPresented presented: UIViewController,
                            presenting: UIViewController,
                            source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SJSideMenuAnimator(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SJSideMenuAnimator(isPresenting: false)
    }
}
