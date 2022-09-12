//
//  TPElement.swift
//  MyFreedom
//
//  Created by m1 on 03.07.2022.
//

import UIKit

enum TPElement {
    enum Id: Equatable {
        case favourites
        case transfers
        case payments
        case publicServices
        case history
        case popularQueries
        case recentRequests
        case searchEmpty
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var buttonTitle: String = "Показать все"
        var elements: TPSection = []
    }
}

typealias TPSection = [TPFieldItemElement<TPItemId>]

enum TPFieldItemType: Equatable {
    case favourites(items: [TPIViewModel])
    case transfers(items: [TPIViewModel])
    case payments(items: [TPIViewModel])
    case publicServices(items: [TPIViewModel])
    case history
    case depositType([DepositItem])
    case recentRequests
    case searchEmpty
    case favoritesEmpty
    case accessory
}

struct TPFieldItemElement<ID: Equatable> {
    let id: ID
    var image: UIImage?
    var title: String
    var subtitle: String? = nil
    var amount: Balance?
    var caption: String? = nil
    var isActive: Bool = true
    var showSeparator: Bool = true
    var accessory: UIImage? = BaseImage.chevronRight.uiImage
    var fieldType: TPFieldItemType
    var isEnabled: Bool = true
}

struct TPIViewModel: Equatable {
    var title: String?
    var icon: BaseImage?
}

enum TPItemId {
    case favourites
    case transfers
    case payments
    case publicServices
    case history
    case popularQueries
    case recentRequests
    case searchEmpty
    case favoritesEmpty
}
