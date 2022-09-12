//
//  EmailChangeInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/12/22.
//

import Foundation

class AddEmailInteractor {

    private var view: AddEmailViewInput

    init(view: AddEmailViewInput) {

        self.view = view
    }
}

extension AddEmailInteractor: AddEmailInteractorInput { }
