//
//  InitialViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

protocol InitialViewInput: BaseViewInput {
    func passData()
}


class InitialViewController: UIViewController {

    var interactor: InitialInteractorInput?
    var router: InitialRouterInput?

    private let backgroundView: UIView = build {
        $0.backgroundColor = .white
    }
    private let logoImageView: UIImageView = build {
        $0.image = BaseImage.logoBig.uiImage
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundView)
        view.addSubview(logoImageView)
        setLayoutConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        interactor?.performTasks()
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += backgroundView.getLayoutConstraints(over: view, safe: false)

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += logoImageView.getLayoutConstraintsByCentering(over: view)

        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension InitialViewController: InitialViewInput {

    func passData() {
        router?.routeToAuthView()
    }
}
