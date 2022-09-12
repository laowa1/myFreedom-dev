//
//  OPElement.swift
//  MyFreedom
//
//  Created by m1 on 07.07.2022.
//

import UIKit

enum OPElement {
    enum Id: Equatable {
        case deposit
        case calculator
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var buttonTitle: String = "Показать все"
        var elements: OPSection = []
    }
}

typealias OPSection = [OPFieldItemElement<OPItemId>]

enum OPFieldItemType: Equatable {
    case depositType([SelectionItemModel])
    case depositInfo([DepositItem])
    case input(DepositSelectedViewController.TextFieldId)
}

struct OPFieldItemElement<ID: Equatable> {
    let id: ID
    var image: UIImage?
    var title: String
    var subtitle: String? = nil
    var value: String? = nil
    var amount: Balance?
    var caption: String? = nil
    var isActive: Bool = true
    var showSeparator: Bool = true
    var accessory: UIImage? = BaseImage.chevronRight.uiImage
    var fieldType: OPFieldItemType
    var isEnabled: Bool = true
}

struct OPIViewModel: Equatable {
    var title: String?
    var icon: BaseImage?
}

enum OPItemId {
    case depositType
    case depositInfo
    case iWantToInvest, iWillReplenishItMonthly
}
