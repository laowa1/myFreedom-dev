//
//  ProfileItemElement.swift
//  MyFreedom
//
//  Created by &&TairoV on 06.05.2022.
//

import UIKit

typealias ProfileSection<ID: Equatable> = [ProfileFieldItemElement<ID>]

enum ProfileTable {

    enum Id: Equatable {
        case digitalDocuments
        case management
        case security
        case settings
        case button
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: ProfileSection<ProfileItemId> = []
    }
}

struct ProfileFieldItemElement<ID: Equatable> {
    let id: ID
    var image: UIImage?
    var title: String
    var subtitle: String? = nil
    var caption: String? = nil
    var accessory: UIImage? = BaseImage.chevronRight.uiImage
    var filedType: ProfileItemFiledType
}

enum ProfileItemFiledType: Equatable {
    case digitalDocuments
    case switcher(isOn: Bool = false)
    case button
    case accessory
}

enum ProfileItemId {
    case digitalDocuments
    case allOperations
    case bonuses
    case monthlyPayments
    case changeNumber
    case addEmail
    case loginWithFaceID
    case changeAccessCode
    case notifications
    case applicationLanguage
    case geolocation
    case theme
    case icon
    case logout
}
