//
//  PDBCardsInteractor.swift
//  MyFreedom
//
//  Created by m1pro on 23.06.2022.
//

import Foundation
import CoreGraphics

protocol PDBCardsInteractorInput: AnyObject {
    
    func getType() -> PDBCardType
    func getCustomY() -> CGFloat
    func getActions() -> [PDActionViewModel]
    func getSpanPoints() -> [PullableSheet.SnapPoint]
    func getSelectedColor() -> GradientColor
    func didSelectItem(type: CardCollectionType, at indexPath: IndexPath)
}

class PDBCardsInteractor {
    
    private unowned var view: PDBCardsViewInput
    private let type: PDBCardType
    private lazy var selectedColor = type.currentGradient
    private let colors = GradientColor.allCases
    
    init(type: PDBCardType, view: PDBCardsViewInput) {
        self.type = type
        self.view = view
    }
    
    func getType() -> PDBCardType { type }
    
    func getCustomY() -> CGFloat { return 330 }
    
    func getActions() -> [PDActionViewModel] {
        switch type {
        case .freedom, .invest:
            return [
                PDActionViewModel(title: "Пополнение", image: .replenishmentAction),
                PDActionViewModel(title: "Перевод", image: .transferAction),
                PDActionViewModel(title: "Снять наличные", image: .paymentAction),
                PDActionViewModel(title: "Платеж", image: .replenishmentAction),
                PDActionViewModel(title: "Конвертация", image: .conversionAction)
            ]
        case .children:
            return [
                PDActionViewModel(title: "Пополнение", image: .replenishmentAction),
                PDActionViewModel(title: "Перевод", image: .transferAction),
                PDActionViewModel(title: "Снять наличные", image: .paymentAction)
            ]
        }
    }
    
    func getSpanPoints() -> [PullableSheet.SnapPoint] {
        return [.min, .custom(y: getCustomY())]
    }

    func getSelectedColor() -> GradientColor {
        return selectedColor
    }

    func didSelectItem(type: CardCollectionType, at indexPath: IndexPath) {
        if type == .theme {
            selectedColor = colors[indexPath.row]
            view.configureBackground()
        }
    }
}

extension PDBCardsInteractor: PDBCardsInteractorInput { }
