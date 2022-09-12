//
//  HomeElementType.swift
//  MyFreedom
//
//  Created by m1 on 28.04.2022.
//

import UIKit

enum HomeTable {
    enum Id: Equatable {
        case story
        case widgets
        case cards
        case deposits
        case credits
        case accounts
        case offers
        case button
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: HomeSection = []
        var isExpand: Bool = false
    }
}

typealias HomeSection = [HomeFieldItemElement]

enum HomeFieldItemType: Equatable {
    case story(items: [BaseImage], shimmer: Bool = false)
    case widgets(items: [WidgetViewModel])
    case card(PDBCardType)
    case deposit(PDBDepositType)
    case credit
    case account
    case offers(items: [OffersViewModel])
    case button
}

struct HomeFieldItemElement {
    var icon: BaseImage?
    var title: String = ""
    var fieldType: HomeFieldItemType
    var description: String?
    var amount: Balance?
    var date: String?
    var isActive: Bool = true
    var showSeparator: Bool = true
    var isMinusBalance: Bool = false
    var connectedToApplePay: Bool = false
    var maturityDate: String?
}

struct Balance {
    let amount: Decimal
    let currency: CurrencyType
}
