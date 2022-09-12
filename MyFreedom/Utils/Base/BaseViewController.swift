//
//  BaseViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

class BaseViewController: UIViewController, BaseViewControllerProtocol, BaseViewInput {

    var baseModalPresentationStyle: UIModalPresentationStyle { .overFullScreen }

    var baseModalTransitionStyle: UIModalTransitionStyle { modalTransitionStyle }

    var topAlertView: UIView?

    var popUpWindow: UIWindow?

    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    private var contentStackTopConstraint: NSLayoutConstraint?

    let navigationSubtitleLabel: CustomSubtitle = .init()
    let scrollView: UIScrollView = build {
        $0.keyboardDismissMode = .onDrag
    }
    let contentStack: UIStackView = build {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fill
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = BaseColor.base50
//        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.largeTitleDisplayMode = .always
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }

    func configure(with top: CGFloat) {
        contentStackTopConstraint?.constant = top
    }

//    private func configureNavigator() {
//        guard let navigationController = navigationController else { return }
//        navigationController.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
//        navigationController.navigationBar.sizeToFit()
//    }

    // MARK: - Setup scroll

    func setupScrollView() {
        view.addSubview(navigationSubtitleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        setLayoutConstraints()
        updateStackSpace(spacing: 16.0)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        navigationSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            navigationSubtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationSubtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            navigationSubtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ]
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            scrollView.topAnchor.constraint(equalTo: navigationSubtitleLabel.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            contentStack.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            contentStack.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func updateStackSpace(spacing: CGFloat = 16.0) {
        contentStack.spacing = spacing
    }
    
    // MARK: - Add to Stack
    func addToStack(_ subview: UIView, at index: Int? = nil, shouldAddConstraints: Bool = true, _ isBottom: Bool = false) {
        if let unwrappedIndex = index {
            contentStack.insertArrangedSubview(subview, at: unwrappedIndex)
        } else {
            contentStack.addArrangedSubview(subview)
        }
        if shouldAddConstraints {
            subview.translatesAutoresizingMaskIntoConstraints = false
        
            var layoutConstraints = [NSLayoutConstraint]()
            layoutConstraints += [
                scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ]
            
            if isBottom {
                layoutConstraints += [
                    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 48)
                ]
            }
            NSLayoutConstraint.activate(layoutConstraints)
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func viewByIndex(tag: Int) -> Int? {
        guard let viewByTag = contentStack.viewWithTag(tag) else { return nil }
        return contentStack.arrangedSubviews.firstIndex(of: viewByTag)
    }
    
    func flushContent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    override func present(
        _ viewController: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        if let viewController = viewController as? BaseViewControllerProtocol {
            viewController.modalPresentationStyle = viewController.baseModalPresentationStyle
            viewController.modalTransitionStyle = viewController.baseModalTransitionStyle
            print(viewController.baseModalPresentationStyle)
        } else {
            viewController.modalPresentationStyle = baseModalPresentationStyle
            viewController.modalTransitionStyle = baseModalTransitionStyle
        }
        super.present(viewController, animated: flag, completion: completion)
    }
}

extension BaseViewController: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if navigationController.isNavigationBarHidden {
            if navigationController.viewControllers.first != viewController {
                navigationController.setNavigationBarHidden(false, animated: animated)
            }
        } else {
            if navigationController.viewControllers.first == viewController {
                navigationController.setNavigationBarHidden(true, animated: animated)
            }
        }
    }
}

extension UINavigationBar {

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 64)
    }
}
