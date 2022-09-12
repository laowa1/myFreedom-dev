//
//  CardRequisitesItemElement.swift
//  MyFreedom
//
//  Created by &&TairoV on 09.06.2022.
//

import UIKit

enum RequisitesFieldType {
    case card
    case requisites
}

struct RequisiteViewModel {
    var type: RequisiteType
    var sections: [RequisitesTable.Section]
}

// MARK: RequisisteTable

enum RequisitesTable {

    enum Id: Equatable {
        case card
        case requisites
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: RequisitesSection = []
        var isExpand: Bool = false
    }
}

typealias RequisitesSection = [RequisitesFieldElement]

struct RequisitesFieldElement {
    var fieldType: RequisitesFieldType
    var description: String?
    var expireDate: String?
    var title: String?
    var icon: UIImage?
    var cardNumber: String?
    var CVV: String?
}

enum RequisiteClipboardType {
    case cardNumber, cvv, requisite
}

enum RequisiteType {
    case account, card
}
