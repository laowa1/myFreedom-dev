//
//  PDBDepositsInteractor.swift
//  MyFreedom
//
//  Created by m1pro on 23.06.2022.
//

import Foundation
import CoreGraphics

protocol PDBDepositsInteractorInput: AnyObject {
    
    func getType() -> PDBDepositType
    func getCustomY() -> CGFloat
    func getActions() -> [PDActionViewModel]
    func getSpanPoints() -> [PullableSheet.SnapPoint]
    func renameDeposit()
}

class PDBDepositsInteractor {
    
    private unowned var view: PDBDepositsViewInput
    private let type: PDBDepositType
    
    init(type: PDBDepositType, view: PDBDepositsViewInput) {
        self.type = type
        self.view = view
    }
    
    func getType() -> PDBDepositType { type }
    
    func getCustomY() -> CGFloat { return type == .capital ? 203 : 330 }
    
    func getActions() -> [PDActionViewModel] {
        switch type {
        case .capital, .none:
            return []
        case .digital:
            return [
                PDActionViewModel(title: "Пополнение", image: .topUp),
                PDActionViewModel(title: "Перевод", image: .transferAction),
                PDActionViewModel(title: "Снять наличные", image: .withdrawСash),
                PDActionViewModel(title: "Платеж", image: .replenishmentAction),
                PDActionViewModel(title: "Конвертация", image: .conversionAction)
            ]
        case .piggyBank:
            return [
                PDActionViewModel(title: "Пополнение", image: .topUp),
                PDActionViewModel(title: "Перевод", image: .transferAction),
                PDActionViewModel(title: "Снять наличные", image: .withdrawСash)
            ]
        case .strategy:
            return [
                PDActionViewModel(title: "Пополнение", image: .topUp),
                PDActionViewModel(title: "Перевод", image: .transferAction)
            ]
        }
    }
    
    func getSpanPoints() -> [PullableSheet.SnapPoint] {
        switch type {
        case .piggyBank:
            return [.custom(y: getCustomY())]
        default:
            return [.min, .custom(y: getCustomY())]
        }
    }
}

extension PDBDepositsInteractor: PDBDepositsInteractorInput {
    func renameDeposit() {
        view.routeToRename(name: "Стратегия 2030")
    }
}
