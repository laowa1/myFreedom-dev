//
//  DepositRenameInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 27.06.2022.
//

import UIKit

protocol DepositRenameInteractorInput {
    func shouldChangeCharactersIn (range: NSRange, replacementString string: String) -> Bool
    func getDepositName() -> String?
}

class DepositRenameInteractor {

    private var view: DepositRenameViewInput?
    private var name: String?

    init(view: DepositRenameViewInput, name: String) {
        self.view = view
        self.name = name
    }
}

extension DepositRenameInteractor: DepositRenameInteractorInput {

    func shouldChangeCharactersIn(range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    func getDepositName() -> String? {
        return name
    }
}
