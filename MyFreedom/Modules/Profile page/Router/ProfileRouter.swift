//
//  ProfileRouter.swift
//  MyFreedom
//
//  Created by &&TairoV on 06.05.2022.
//

import Foundation

class ProfileRouter {
    
    private var view: ProfileViewInput?
    private unowned let commonStore: CommonStore
    
    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }
    
    func build() -> ProfileViewInput {
        let viewController = ProfileViewController()
        let interactor = ProfileInteractor(view: viewController, logger: commonStore.logger)
        
        view = viewController
        viewController.interactor = interactor
        viewController.router = self
        
        return viewController
    }
}

extension ProfileRouter: ProfileRouterInput {
    
    func popViewContoller() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToAddEmail(delegate: AddEmailDelegate) {
        let vc = AddEmailRouter(delegate: delegate, commonStore: commonStore).build()
        view?.push(vc)
    }
    
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol) {
        view?.presentBottomDrawerViewController(with: module)
    }
    
    func updateAllViews() {
        let menuRouter = MainTabBarRouter(commonStore: commonStore).build()
        let navigationController = NavigationController(rootViewController: menuRouter)
        
        (menuRouter.viewControllers?.first as? HomeViewController)?.router?.routeToProfile(animated: false)
        
        commonStore.rootWindow?.rootViewController = navigationController
    }
    
    func routeToEnterCurrentAC(type: String, delegate: AccessCodeConfirmFaceDelegate) {
        let vc = CUAccessCodeRouter(delegate: delegate, commonStore: commonStore, type: .confirmFace(type: type)).build()
        view?.push(vc)
    }
    
    func routeToChangeAC(delegate: AccessCodeChangeDelegate) {
        let vc = CUAccessCodeRouter(delegate: delegate, commonStore: commonStore, type: .change).build()
        view?.push(vc)
    }
    
    func routeChangeNumber(delegate: ChangePhoneDelegate) {
        let vc = ChangePhoneNumberRouter(delegate: delegate, commonStore: commonStore).build()
        view?.push(vc, animated: true)
    }
    
    func routeToActivateDigitalDocument() {
        let vc = SixDigitVerificationRouter(parentRouter: self,
                                            commonStore: commonStore,
                                            resendTime: commonStore.codeConfirmationResendTime,
                                            id: UUID()).build()
        view?.push(vc)
    }
    
    func routeToDigitalDocumentStories() {
        let vc = StoriesRouter(commonStore: commonStore,
                               delegate: self,
                               buttonTitle: "Добавить документы",
                               buttonImage: .document).build()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = view
        view?.present(vc, animated: true)
    }
    
    func routeToDigitalDocument(title: String, url: URL) {
        let webView = DigitalDocumentsRouter(commonStore: commonStore, title: title, url: url).build()
        view?.push(webView)
    }
    
    func closeSession() {
        view?.dismiss(animated: false)
    }
}

extension ProfileRouter: VerificationParentRouter {
    
    func confirm(id: UUID) {}
    
    func fail(id: UUID) { }
    
    func resend(id: UUID) { }
}

extension ProfileRouter: StoriesDelegate {
    
    func nextButtonAction() {
        routeToActivateDigitalDocument()
    }
}
