//
//  SJSideMenuViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 10/9/25.
//

import UIKit

import SnapKit
import Then

protocol SJSideMenuDelegate: AnyObject {
    func sideMenuWillAppear()
    func sideMenuDidAppear()
    func sideMenuWillDisappear()
    func sideMenuDidDisappear()
}

final class SJSideMenuViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: SJSideMenuDelegate?
    private let contentViewController: UIViewController
    private let transitionDelegate: SJSideMenuTransitionDelegate
    private weak var attachedViewController: UIViewController?
    private var edgePanGesture: UIScreenEdgePanGestureRecognizer?

    // MARK: - UI Components

    private let containerView = UIView()

    // MARK: - Initializer

    init(contentViewController: UIViewController, menuWidth: CGFloat = UIScreen.main.bounds.width * 0.8) {
        self.contentViewController = contentViewController
        self.transitionDelegate = SJSideMenuTransitionDelegate(menuWidth: menuWidth)
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = transitionDelegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setHierarchy()
        setLayout()
        setStyle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.sideMenuWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.sideMenuDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.sideMenuWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.sideMenuDidDisappear()
    }

    // MARK: - Setup

    private func setHierarchy() {
        view.addSubview(containerView)

        addChild(contentViewController)
        containerView.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }

    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setStyle() {
        view.do {
            $0.backgroundColor = .bg100
        }

        containerView.do {
            $0.backgroundColor = .clear
        }
    }

    // MARK: - Public Methods

    /// 다른 ViewController에 SideMenu를 연결합니다.
    func attachToViewController(_ viewController: UIViewController) {
        self.attachedViewController = viewController

        // Edge Pan Gesture 추가
        let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        panGesture.edges = .left
        viewController.view.addGestureRecognizer(panGesture)
        self.edgePanGesture = panGesture
    }

    /// SideMenu를 표시합니다.
    func show() {
        guard let attachedVC = attachedViewController else { return }
        attachedVC.present(self, animated: true)
    }

    /// SideMenu를 닫습니다.
    func hide() {
        dismiss(animated: true)
    }

    // MARK: - Private Methods

    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let attachedVC = attachedViewController else { return }

        let translation = gesture.translation(in: gesture.view)
        let percent = translation.x / (gesture.view?.bounds.width ?? 1)

        switch gesture.state {
        case .began:
            show()

        case .changed:
            // 스와이프 진행 중 처리 (선택적)
            break

        case .ended, .cancelled:
            // 스와이프 완료 처리
            let velocity = gesture.velocity(in: gesture.view)
            if velocity.x < 0 || percent < 0.3 {
                hide()
            }

        default:
            break
        }
    }
}

// MARK: - HomeViewController 연동을 위한 Extension

extension SJSideMenuViewController {

    /// HomeViewController의 mapView 알파값을 조절합니다.
    func updateBackgroundAlpha(_ alpha: CGFloat, for viewController: UIViewController) {
        // HomeViewController의 mapView 접근이 필요한 경우
        // 추가적인 델리게이트 패턴이나 클로저를 사용할 수 있습니다.
    }
}
