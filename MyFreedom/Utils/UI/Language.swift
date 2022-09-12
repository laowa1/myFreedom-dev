//
//  Language.swift
//  MyFreedom
//
//  Created by m1pro on 15.05.2022.
//

import Foundation

enum Language: String, CaseIterable {

    case ru, kk, en

    static var `default`: Language { .ru }

    var code: RawValue { rawValue }
    var locale: Locale { .init(identifier: rawValue) }

    var title: String {
        switch self {
        case .ru: return "Русский".localized
        case .kk: return "Қазақ".localized
        case .en: return "English".localized
        }
    }

    init?(code: RawValue) {
        self.init(rawValue: code)
    }
}
