//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ___VARIABLE_sceneName___ViewController: BaseViewController {

    var interactor: ___VARIABLE_sceneName___InteractorInput?
    var router: ___VARIABLE_sceneName___RouterInput?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        addSubviews()
        setupLayout()
        stylize()
        setActions()
    }

    private func addSubviews() {

    }

    private func setupLayout() {
    	var layoutConstraints = [NSLayoutConstraint]()

    	layoutConstraints += [
    	]

    	NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {

    }

    private func setActions() {

    }
}

extension ___VARIABLE_sceneName___ViewController: ___VARIABLE_sceneName___ViewInput {

}
