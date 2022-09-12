//
//  PDLimitsElement.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import Foundation

struct PDLimitsElement {
    var title: String = ""
    var amount: Balance?
    var usedUp: Balance?
    var left: Balance? {
        guard let amount = amount, let usedUp = usedUp else { return nil }
        return Balance(amount: amount.amount - usedUp.amount, currency: amount.currency)
    }
    var alertTitle: String?
    var alertSubtitle: String?
    var isActive: Bool = true
}
