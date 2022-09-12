//
//  PDBAccountsInteractor.swift
//  MyFreedom
//
//  Created by m1pro on 23.06.2022.
//

import Foundation
import CoreGraphics

protocol PDBAccountsInteractorInput: AnyObject {
    
    func getCustomY() -> CGFloat
    func getActions() -> [PDActionViewModel]
    func getSpanPoints() -> [PullableSheet.SnapPoint]
}

class PDBAccountsInteractor {
    
    private unowned var view: PDBAccountsViewInput
    
    init(view: PDBAccountsViewInput) {
        self.view = view
    }
    
    func getCustomY() -> CGFloat { return 300 }
    
    func getActions() -> [PDActionViewModel] {
        return [
            PDActionViewModel(title: "Пополнение", image: .replenishmentAction),
            PDActionViewModel(title: "Перевод", image: .transferAction)
        ]
    }
    
    func getSpanPoints() -> [PullableSheet.SnapPoint] {
        return [.custom(y: getCustomY())]
    }
}

extension PDBAccountsInteractor: PDBAccountsInteractorInput { }
