//
//  IncomeCardItemElement.swift.swift
//  MyFreedom
//
//  Created by &&TairoV on 24.06.2022.
//

import UIKit

enum IncomeCardTable {

    enum Id: Equatable {
        case total
        case period
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: IncomeCardSection = []
        var isExpand: Bool = false
    }
}

typealias IncomeCardSection = [IncomeCardFieldElement]

struct IncomeCardFieldElement {
    var fieldType: IncomeCardFieldType
    var description: String?
    var title: String?
    var precent: String?
    var totalReward: String?
    var showSeparator: Bool = true
}

enum IncomeCardFieldType {
    case total, period
}
