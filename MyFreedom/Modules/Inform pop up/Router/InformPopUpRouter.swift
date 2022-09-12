//
//  InformPopUpRouter.swift
//  MyFreedom
//
//  Created by Sanzhar on 15.03.2022.
//

import UIKit

final class InformPopUpRouter: InformPopUpRouterInput {
    
    private weak var view: InformPopUpViewInput?
    private weak var delegate: InformPUButtonDelegate?
    private let popToRoot: Bool
    private var model: InformPUViewModel?
    
    init(delegate: InformPUButtonDelegate, model: InformPUViewModel?, popToRoot: Bool = true) {
        self.delegate = delegate
        self.model = model
        self.popToRoot = popToRoot
    }
    
    func build() -> InformPopUpViewInput {
        let viewController = InformPopUpViewController()
        view = viewController
        
        viewController.router = self
        viewController.configure(model: model)
        return viewController
    }
    
    func buttonAction(type: InformPUButtonType, id: UUID) {
        delegate?.buttonPressed(type: type, id: id)
    }

    func routeToBack() {
        if popToRoot {
            view?.navigationController?.popToRootViewController(animated: true)
        } else {
            view?.navigationController?.popViewController(animated: true)
        }
    }
    
    func routeToWebview(title: String, url: URL) {
        let webView = WebViewController()
        webView.set(title: title, url: url)

        view?.dismiss(animated: true) { [weak self] in
            self?.view?.present(webView, animated: true)
        }
    }
}
