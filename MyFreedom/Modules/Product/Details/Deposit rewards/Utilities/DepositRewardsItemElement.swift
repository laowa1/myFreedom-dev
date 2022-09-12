//
//  DepositRewardsItemElement.swift.swift
//  MyFreedom
//
//  Created by &&TairoV on 24.06.2022.
//

import UIKit

enum DepositRewardsTable {

    enum Id: Equatable {
        case total
        case period
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: DepositRewardsSection = []
        var isExpand: Bool = false
    }
}

typealias DepositRewardsSection = [DepositRewardsFieldElement]

struct DepositRewardsFieldElement {
    var fieldType: DepositRewardsFieldType
    var description: String?
    var title: String?
    var precent: String?
    var totalReward: String?
}

enum DepositRewardsFieldType {
    case total, period
}
