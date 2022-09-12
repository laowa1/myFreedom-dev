//
//  CDIInteractor.swift
//  MyFreedom
//
//  Created by Sanzhar on 28.06.2022.
//

import Foundation

class CDIInteractor {
    
    private unowned var view: CDIViewInput
    
    init(view: CDIViewInput) {
        self.view = view
    }
}

extension CDIInteractor: CDIInteractorInput {
    
}
