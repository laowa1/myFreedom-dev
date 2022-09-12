//
//  PDBCardsViewContoller.swift
//  MyFreedom
//
//  Created by m1pro on 22.06.2022.
//

import UIKit

protocol PDBCardsViewInput: BaseViewController {
    func configureBackground()
}

class PDBCardsViewContoller: BaseViewController {
    
    var router: PDBCardsRouterInput?
    var interactor: PDBCardsInteractorInput?
    var containerController: PDBCardContainerViewInput?

    private lazy var navigationView: CustomNavigation = build {
        $0.leftButton.setImage(BaseImage.back.template, for: .normal)
        $0.leftButton.tintColor = .white
        $0.leftButtonInset = 16
        $0.leftButtonWidth = 24
        if let interactor = interactor, interactor.getType() == .children {
            $0.title = "Детская карта"
            $0.image = BaseImage.productEdit
            $0.button.isUserInteractionEnabled = true
            $0.button.actionClick = ActionClick(block: { [weak self] sender in
                self?.router?.routeToRenameCard(name: "Детская карта")
            })
        } else {
            $0.rightButtonIcon = BaseImage.changeTheme
            $0.rightButtonInset = 16
            $0.rightButtonWidth = 32

            $0.title = "Карта "
            $0.image = BaseImage.visaTitle
        }

        $0.titleLabel.font = BaseFont.medium
        $0.titleLabel.textColor = BaseColor.base50

        $0.rightButtonAction = { [weak self] in self?.showChangeTheme() }
        $0.leftButtonAction = { [weak self] in self?.navigationController?.popViewController(animated: true) }
    }

    private var sheet: PullableSheet?
    
    private let backgroundView = PDBCardsView()
    
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
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(layoutConstraints)

        backgroundView.delegate = self
        backgroundView.saveThemeAction = { [weak self] in
            self?.hideChangeTheme()
        }
        configureBackground()
        
        guard let viewController = containerController, let interactor = interactor else {
            return
        }
        
        viewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewController.view.layer.cornerRadius = 12
        viewController.view.layer.masksToBounds = true
        
        sheet = PullableSheet(content: viewController, topBarStyle: .custom(UIView()))
        sheet?.snapPoints = interactor.getSpanPoints()
        sheet?.scroll(toY: interactor.getCustomY(), duration: 0)
        sheet?.add(to: self)
    }
    
    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    private func showChangeTheme() {
        sheet?.scroll(toY: PullableSheet.SnapPoint.max.y, duration: 0.5)
        navigationView.leftButton.isHidden = true
        navigationView.rightButtonIcon = BaseImage.roundClose
        navigationView.rightButtonAction = { [weak self] in
            self?.hideChangeTheme()
        }
    }

    private func hideChangeTheme() {
        navigationView.leftButton.isHidden = false
        navigationView.rightButtonIcon = BaseImage.changeTheme
        sheet?.scroll(toY: interactor?.getCustomY() ?? 0, duration: 0.5)
        navigationView.rightButtonAction = { [weak self] in
            self?.showChangeTheme()
        }
    }

}

extension PDBCardsViewContoller: PDBCardsViewInput {

    func configureBackground() {
        if let interactor = interactor {
            backgroundView.configure(
                type: interactor.getType(),
                items: interactor.getActions(),
                selectedColor: interactor.getSelectedColor()
            )
        }
    }
}

extension PDBCardsViewContoller: PDBannerViewDelegate {

    func didSelectItem(type: CardCollectionType, at indexPath: IndexPath) {
        interactor?.didSelectItem(type: type, at: indexPath)
    }
}
