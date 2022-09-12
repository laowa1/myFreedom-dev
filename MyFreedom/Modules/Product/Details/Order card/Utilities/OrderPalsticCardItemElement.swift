//
//  OrderPlasticCardItemElement.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit.UIImage

enum OrderPlasticCardType {
    case order, reissue
}

enum OrderPalsticCardTable {

    enum Id: Equatable {
        case info
        case address
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: OrderPalsticCardSection = []
        var isExpand: Bool = false
    }
}

typealias OrderPalsticCardSection = [OrderPalsticCardElement]

enum OrderPalsticCardFieldType {
    case info
    case city
    case street
    case flat(flat: String, flatValue: String? = nil, entrance: String, entranceValue: String? = nil)
}

enum OrderPlasticCardItemId: Equatable {
    case info
    case city
    case street
    case flatEntrance
}

struct OrderPalsticCardElement {
    var fieldType: OrderPalsticCardFieldType
    var description: String?
    var title: String?
    var text: String? = nil
    var icon: UIImage?
    let id: OrderPlasticCardItemId
}
