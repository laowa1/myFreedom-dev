//
//  DCAProductType.swift
//  MyFreedom
//
//  Created by Sanzhar on 04.05.2022.
//

import UIKit

enum DCAProductType {
    case deposit, credit(type: CreditProductType), account(currency: CurrencyType)

    var icon: BaseImage? {
        switch self {
        case .deposit:
            return BaseImage.deposit
        case .credit(let type):
            switch type {
            case .credit:
                return BaseImage.kzt
            case .mortgage:
                return BaseImage.mortgage
            case .carLoan:
                return BaseImage.carLoan
            }
        case .account(let currency):
            switch currency {
            case .KZT:
                return BaseImage.kzt
            case .USD:
                return BaseImage.usd
            case .EUR:
                return BaseImage.eur
            case .RUB:
                return BaseImage.rub
            default:
                return nil
            }
        }
    }
}

enum CreditProductType {
    case credit, mortgage, carLoan
}
