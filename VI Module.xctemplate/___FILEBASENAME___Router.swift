//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

class ___VARIABLE_sceneName___Router {

    private unowned let commonStore: CommonStore
    private weak var view: ___VARIABLE_sceneName___ViewInput?

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func build() -> ___VARIABLE_sceneName___ViewInput {
        let viewController = ___VARIABLE_sceneName___ViewController()
        view = viewController

        let interactor = ___VARIABLE_sceneName___Interactor(view: viewController)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension ___VARIABLE_sceneName___Router: ___VARIABLE_sceneName___RouterInput {

}
