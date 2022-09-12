//
//  PDBDepositContainerElement.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

typealias PDBDepositContainerSection<ID: Equatable> = [PDBDepositContainerFieldElement<ID>]

enum PDBDepositContainerTable {

    enum Id: Equatable {
        case pdBanner
        case detail
        case settings
        case recentOperations
        case remunaration
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: PDBDepositContainerSection<PDBDepositContainerItemId> = []
    }
}

struct PDBDepositContainerFieldElement<ID: Equatable> {
    let id: ID
    var image: UIImage?
    var title: String
    var subtitle: String? = nil
    var amount: Balance?
    var caption: String? = nil
    var isActive: Bool = true
    var showSeparator: Bool = true
    var accessory: UIImage? = BaseImage.chevronRight.uiImage
    var filedType: PDBDepositContainerFiledType
    var isEnabled: Bool = true
}

enum PDBDepositContainerFiledType: Equatable {
    case accessory
    case recentOperations
    case remunaration
    case switcher(isOn: Bool = false)
    case pdBanner(items: [PDBannerViewModel])
}

enum PDBDepositContainerItemId {
    case remunaration
    case pdBanner
    case pdLock
    case pdInternetPayments
    case pdFavorites
    case pdLimits
    case pdChangePin
    case pdPlastic
    case pdCloseCard
    case pdReferences
    case pdConditions
    case pdRequisites
    case pdItem
}
