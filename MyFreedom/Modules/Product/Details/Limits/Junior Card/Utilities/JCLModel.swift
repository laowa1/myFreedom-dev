//
//  JCLModel.swift
//  MyFreedom
//
//  Created by Sanzhar on 01.07.2022.
//

import Foundation

struct JCLModel {
    
    enum LimitId {
        case withdraw, internetPayments, transfer
    }
    
    struct Limits {
        let id: LimitId
        var limit: Decimal
        var usedUp: Decimal
        var period: JCLDetailPeriod
    }
    
    struct Currencies {
        let currencyType: CurrencyType
        var isEnabled: Bool
    }
    
    var limits: [Limits]
    var blockedPayments: [JCLPayments]
    var currencies: [Currencies]
}



enum JCLContainerTable {
    
    enum Id: Equatable {
        case limits
        case blockedPayments
        case currencies
    }
    
    struct Section {
        let id: Id
        var title: String? = nil
        var header: String? = nil
        var limits: [PDLimitsElement]? = nil
        var currencies: [JCLModel.Currencies]? = nil
    }
}
