//
//  CDIRouter.swift
//  MyFreedom
//
//  Created by Sanzhar on 28.06.2022.
//

import Foundation

class CDIRouter {
    
    private var view: CDIViewInput?
    private unowned let commonStore: CommonStore
    private var model: InputLevelModel
    private weak var delegate: CDIUpdaterDelegate?
    
    init(commonStore: CommonStore, model: InputLevelModel, delegate: CDIUpdaterDelegate?) {
        self.commonStore = commonStore
        self.model = model
        self.delegate = delegate
    }
    
    func build() -> CDIViewInput {
        let viewController = CDIViewController(currentLevel: model.currentLevelIndex, maxLevel: model.levels.count)
        let interactor = CDIInteractor(view: viewController)
        
        view = viewController
        viewController.router = self
        viewController.interactor = interactor
        viewController.model = model.levels[safe: model.currentLevelIndex]
        
        return viewController
    }
}

extension CDIRouter: CDIRouterInput {
    
    private func pushViewController(currentIndex: Int, animated: Bool) {
        let vc = CDIRouter(commonStore: commonStore, model: model, delegate: delegate).build()
        view?.push(vc, removeCurrent: true, animated: animated)
    }
    
    func routeToNext() {
        model.currentLevelIndex += 1
        model.currentLevelIndex == model.levels.count ?
                    routeToParent() : pushViewController(currentIndex: model.currentLevelIndex, animated: true)
    }
    
    func routeToPrevius() {
        model.currentLevelIndex -= 1
        pushViewController(currentIndex: model.currentLevelIndex, animated: false)
    }
    
    func routeToParent() {
        delegate?.update()
        view?.dismiss(animated: true)
    }
}
