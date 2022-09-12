//
//  PDBAccountContainerElement.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

typealias PDBAccountContainerSection<ID: Equatable> = [PDBAccountContainerFieldElement<ID>]

enum PDBAccountContainerTable {

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
        var elements: PDBAccountContainerSection<PDBAccountContainerItemId> = []
    }
}

struct PDBAccountContainerFieldElement<ID: Equatable> {
    let id: ID
    var image: UIImage?
    var title: String
    var subtitle: String? = nil
    var amount: Balance?
    var caption: String? = nil
    var isActive: Bool = true
    var showSeparator: Bool = true
    var accessory: UIImage? = BaseImage.chevronRight.uiImage
    var filedType: PDBAccountContainerFiledType
    var isEnabled: Bool = true
}

enum PDBAccountContainerFiledType: Equatable {
    case accessory
    case recentOperations
}

enum PDBAccountContainerItemId {
//    case remunaration
//    case pdBanner
//    case pdLock
//    case pdInternetPayments
//    case pdFavorites
//    case pdLimits
//    case pdChangePin
//    case pdPlastic
//    case pdCloseCard
//    case pdConditions
    case pdReferences
    case pdItem
    case pdRequisites
}
