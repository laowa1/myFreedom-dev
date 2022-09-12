//
//  StoryPageRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.03.2022.
//

import Foundation
import UIKit

protocol StoriesDelegate: AnyObject {
    var showNextButton: Bool { get }
    var showCloseButton: Bool { get }
    var routeToAuth: Bool { get }

    func nextButtonAction()
}

extension StoriesDelegate {
    var showCloseButton: Bool { true }
    var showNextButton: Bool { true }
    var routeToAuth: Bool  { false }
}

class StoriesRouter {
    
    private weak var view: StoriesViewInput?
    private unowned let commonStore: CommonStore
    private weak var delegate: StoriesDelegate?
    
    private var buttonTitle: String
    private var buttonImage: BaseImage?


    init(commonStore: CommonStore,
         delegate: StoriesDelegate? = nil,
         buttonTitle: String = "Начать",
         buttonImage: BaseImage? = nil,
         buttonAction: (() -> Void)? = nil) {
        
        self.commonStore = commonStore
        self.delegate = delegate
        self.buttonTitle = buttonTitle
        self.buttonImage = buttonImage

    }

    func build() -> StoriesViewInput {
        let viewController = StoriesViewController()
        let interactor = StoriesInteractor(view: viewController,
                                           buttonTitle: buttonTitle,
                                           buttonImage: buttonImage)
        
        view = viewController
        viewController.interactor = interactor
        viewController.delegate = delegate
        viewController.router = self
        
        return viewController
    }
}

extension StoriesRouter: StoriesRouterInput {
    
    func routeToAuthPage() {
        let viewController = MainTabBarRouter(commonStore: commonStore).build()
        let nav = NavigationController(rootViewController: viewController)
        view?.present(nav, animated: true)
    }
    
    func routeToBack() {
        view?.dismiss(animated: true)
    }
}
