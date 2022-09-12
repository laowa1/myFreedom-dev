//
//  CreatePasswordInteractor.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 31.03.2022.
//

import Foundation

protocol CreatePasswordInteractorInput: AnyObject { }

class CreatePasswordInteractor {

    private unowned let view: CreatePasswordViewInput

    init(view: CreatePasswordViewInput) {
        self.view = view
    }
}

extension CreatePasswordInteractor: CreatePasswordInteractorInput { }
