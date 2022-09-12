//
//  PDBCardContainerElement.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

typealias PDBCardContainerSection<ID: Equatable> = [PDBCardContainerFieldElement<ID>]

enum PDBCardContainerTable {

    enum Id: Equatable {
        case pdBanner
        case detail
        case settings
        case recentOperations
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: PDBCardContainerSection<PDBCardContainerItemId> = []
    }
}

struct PDBCardContainerFieldElement<ID: Equatable> {
    let id: ID
    var image: UIImage?
    var title: String
    var subtitle: String? = nil
    var amount: Balance?
    var caption: String? = nil
    var isActive: Bool = true
    var showSeparator: Bool = true
    var accessory: UIImage? = BaseImage.chevronRight.uiImage
    var filedType: PDBCardContainerFiledType
    var isEnabled: Bool = true
}

enum PDBCardContainerFiledType: Equatable {
    case accessory
    case recentOperations
    case switcher(isOn: Bool = false)
    case pdBanner(items: [PDBannerViewModel])
}

enum PDBCardContainerItemId {
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
    case pdOperationNotifications
    case pdAutoTopup
}
