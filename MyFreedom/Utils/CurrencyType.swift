//
//  CurrencyType.swift
//  MyFreedom
//
//  Created by Sanzhar on 03.05.2022.
//

import UIKit

enum CurrencyType: String, Equatable, CaseIterable, Codable {
    case KZT, USD, EUR, RUB, GBP, CNY
    
    var code: RawValue { rawValue }
    
    var symbol: String {
        switch self {
        case .KZT:
            return "₸"
        case .USD:
            return "$"
        case .EUR:
            return "€"
        case .RUB:
            return "₽"
        case .GBP:
            return "£"
        case .CNY:
            return "¥"
        }
    }
    
    var title: String {
        switch self {
        case .KZT:
            return "Тенге"
        case .USD:
            return "Доллар"
        case .EUR:
            return "Евро"
        case .RUB:
            return "Рубль"
        case .GBP:
            return "Фунты стерлинга"
        case .CNY:
            return "Китайский юань"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .KZT:
            return BaseImage.kzt.uiImage
        case .USD:
            return BaseImage.usd.uiImage
        case .EUR:
            return BaseImage.eur.uiImage
        case .RUB:
            return BaseImage.rub.uiImage
        default:
            return nil
        }
    }
    
    init?(code: RawValue) { self.init(rawValue: code) }
}
