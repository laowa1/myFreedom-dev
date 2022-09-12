//
//  JCLPayments.swift
//  MyFreedom
//
//  Created by Sanzhar on 01.07.2022.
//

import UIKit

enum JCLPayments: CaseIterable {
    case mobileCommunication, internet, transport, publicServices, education, cableTv, games
    
    var icon: UIImage? {
        switch self {
        case .mobileCommunication:
            return BaseImage.pdReferences.uiImage
        case .internet:
            return BaseImage.pdReferences.uiImage
        case .transport:
            return BaseImage.pdReferences.uiImage
        case .publicServices:
            return BaseImage.pdReferences.uiImage
        case .education:
            return BaseImage.pdReferences.uiImage
        case .cableTv:
            return BaseImage.pdReferences.uiImage
        case .games:
            return BaseImage.pdReferences.uiImage
        }
    }
    
    var title: String? {
        switch self {
        case .mobileCommunication:
            return "Мобильная связь"
        case .internet:
            return "Интернет, ТВ"
        case .transport:
            return "Транспорт"
        case .publicServices:
            return "Госуслги"
        case .education:
            return "Образование"
        case .cableTv:
            return "Кабельное телевидение"
        case .games:
            return "Игры"
        }
    }
}
