//
//  BaseDrawerContainer.swift
//  MyFreedom
//
//  Created by &&TairoV on 17.03.2022.
//

import UIKit

final class BaseDrawerContainerViewController: UIViewController {
    private let contentViewController: BaseDrawerContentViewControllerProtocol

    private lazy var backgroundView: UIView = build {
        $0.backgroundColor = BaseColor.base900.withAlphaComponent(0.5)
        $0.isUserInteractionEnabled = true
        if contentViewController.isDismissEnabled {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
            $0.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    private let containerView = UIView()

    private var containerViewMinY: CGFloat = 0
    private let animationDuration = 0.3

    public init(contentViewController: BaseDrawerContentViewControllerProtocol) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
        contentViewController.view.isHidden = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setNeededFramesThenPresent()
    }

    func addSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        addChild(contentViewController)
        containerView.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }

    func setLayoutConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(backgroundView.getLayoutConstraints(over: self.view, safe: false))
    }

    func setNeededFramesThenPresent(updatingViewFrame: Bool = false) {
        let containerViewHeight: CGFloat
        let bottom: CGFloat
        if #available(iOS 11.0, *) {
            bottom = view.safeAreaInsets.bottom
        } else {
            bottom = bottomLayoutGuide.length
        }
        let contentViewHeightWithInset = contentViewController.contentViewHeight + bottom

        if contentViewHeightWithInset >= view.frame.height {
            containerViewHeight = view.frame.height - (statusBarFrame?.height ?? 0)
            containerViewMinY = statusBarFrame?.height ?? 0
        } else {
            let totalContainerViewHeight = contentViewHeightWithInset
            if let statusBarHeight = statusBarFrame?.height,
               view.frame.height - totalContainerViewHeight <= statusBarHeight {
                containerViewHeight = view.frame.height - statusBarHeight
                containerViewMinY = statusBarHeight
            } else {
                containerViewHeight = totalContainerViewHeight
                containerViewMinY = view.frame.height - containerViewHeight
            }
        }

        let contentViewHeight = containerViewHeight

        containerView.frame = CGRect(
            x: 0,
            y: !updatingViewFrame ? view.frame.maxY : containerView.frame.origin.y,
            width: view.frame.width,
            height: containerViewHeight
        )

        contentViewController.view.frame = CGRect(
            x: 0,
            y: view.frame.minY,
            width: view.frame.width,
            height: contentViewHeight
        )

        if !updatingViewFrame {
            contentViewController.view.isHidden = false
        }

        presentContentView()
    }

    private func stylize() {
        backgroundView.alpha = 0

        if let scrollView = contentViewController.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            scrollView.bounces = false
        }
    }

    private func setActions() {
        guard contentViewController.isScrollEnabled else { return }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag))
        panGesture.delegate = self
        containerView.addGestureRecognizer(panGesture)
    }

    private func presentContentView() {
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut
        ) { [weak self] in
            guard let self = self else { return }
            self.containerView.frame.origin.y = self.containerViewMinY
            self.backgroundView.alpha = 1
        }
    }

    private func dismissContentView(_ completion: ((Bool) -> Void)?) {
        guard contentViewController.isAnimatedDismissEnabled else {
            completion?(true)
            return
        }
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: { [weak self] in
                guard let self = self else { return }
                self.containerView.frame.origin.y = self.view.frame.maxY
                self.backgroundView.alpha = 0
            },
            completion: completion
        )
    }

    @objc private func drag(_ gesture: UIPanGestureRecognizer) {
        view.endEditing(true)
        let translation = gesture.translation(in: containerView)
        let y = containerView.frame.minY

        if gesture.state == .changed {
            if let statusBarHeight = statusBarFrame?.height,
               translation.y < 0,
               y + translation.y <= statusBarHeight {
                containerView.frame.origin.y = statusBarHeight
            } else {
                if y + translation.y > containerViewMinY {
                    UIView.animate(
                        withDuration: animationDuration,
                        delay: 0,
                        usingSpringWithDamping: 1,
                        initialSpringVelocity: 1,
                        options: [.allowUserInteraction, .curveEaseOut]
                    ) { [weak self] in
                        guard let self = self else { return }
                        self.containerView.frame.origin.y = y + translation.y
                    }
                }
            }
        } else if gesture.state == .ended {
            if y < containerViewMinY + containerView.frame.height / 3 {
                resetContentView()
            } else {
                if contentViewController.isDismissEnabled {
                    dismissAction()
                } else {
                    resetContentView()
                }
            }
        }

        gesture.setTranslation(.zero, in: containerView)
    }

    private func resetContentView() {
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [.allowUserInteraction, .curveEaseOut]
        ) { [weak self] in
            guard let self = self else { return }
            self.containerView.frame.origin.y = self.containerViewMinY
        }
    }

    @objc private func tapGestureAction() {
        guard contentViewController.isDismissEnabled else { return }
        dismissAction()
    }

    @objc public func dismissAction(_ completion: (() -> Void)? = nil) {
        dismissContentView { [weak self] _ in
            self?.dismiss(animated: true, completion: completion)
        }
    }

    public func updateViewFrame() {
        setNeededFramesThenPresent(updatingViewFrame: true)
    }
}

extension BaseDrawerContainerViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        let subviews = contentViewController.view.subviews
        guard let scrollView = subviews.first(where: { $0 is UIScrollView }) as? UIScrollView else { return false }
        return scrollView.contentOffset.y <= 0
    }
}
