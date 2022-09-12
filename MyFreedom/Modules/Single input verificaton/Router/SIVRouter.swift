//
//  SIVRouter.swift
//  MyFreedom
//
//  Created by Sanzhar on 17.03.2022.
//

import Foundation

final class SIVRouter<T: SIVInteractorInput> {
    
    private weak var view: SIVViewInput?
    private var interactor: T
    private let delegate: SIVConfirmButtonDelegate?
    
    init(interactor: T, delegate: SIVConfirmButtonDelegate?) {
        self.interactor = interactor
        self.delegate = delegate
    }
    
    func build() -> SIVViewInput {
        let viewController = SIVViewController<T>()
        view = viewController
        
        interactor.view = view
        
        viewController.router = self
        viewController.interactor = interactor
        viewController.delegate = delegate
        
        return viewController
    }
}

extension SIVRouter: SIVRouterInput {

    func popToRoot() {
        view?.navigationController?.popToRootViewController(animated: true)
    }
}
