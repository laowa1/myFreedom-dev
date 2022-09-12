//
//  PDBAccountsViewContoller.swift
//  MyFreedom
//
//  Created by m1pro on 22.06.2022.
//

import UIKit

protocol PDBAccountsViewInput: BaseViewController { }

class PDBAccountsViewContoller: BaseViewController {
    
    var router: PDBAccountsRouterInput?
    var interactor: PDBAccountsInteractorInput?
    var containerController: PDBAccountContainerViewInput?

    private lazy var navigationView: CustomNavigation = build {
        $0.leftButton.setImage(BaseImage.back.template, for: .normal)
        $0.leftButton.tintColor = .white
        $0.leftButtonInset = 16
        $0.leftButtonWidth = 24
        $0.title = "Текущий счет **7809"
        $0.image = BaseImage.visaTitle
        $0.titleLabel.font = BaseFont.medium
        $0.titleLabel.textColor = BaseColor.base50
        
        $0.leftButtonAction = { [weak self] in self?.navigationController?.popViewController(animated: true) }
    }
    
    private let backgroundView = PDBAccountsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        view.addSubview(navigationView)
        
        var layoutConstraints = [NSLayoutConstraint]()
        
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 360),
        ]
        NSLayoutConstraint.activate(layoutConstraints)
        
        guard let viewController = containerController, let interactor = interactor else {
            return
        }
        
        backgroundView.configure(
            items: interactor.getActions()
        )
        
        viewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewController.view.layer.cornerRadius = 12
        viewController.view.layer.masksToBounds = true
        
        let sheet = PullableSheet(content: viewController, topBarStyle: .custom(UIView()))
        sheet.snapPoints = interactor.getSpanPoints()
        sheet.scroll(toY: interactor.getCustomY(), duration: 0)
        sheet.add(to: self)
    }
    
    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

extension PDBAccountsViewContoller: PDBAccountsViewInput { }
