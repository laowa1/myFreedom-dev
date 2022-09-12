//
//  JCLDetailPeriod.swift
//  MyFreedom
//
//  Created by Sanzhar on 04.07.2022.
//

import Foundation

enum JCLDetailPeriod {
    case day, week, month, unlimit
    
    var title: String? {
        switch self {
        case .day:
            return "В день"
        case .week:
            return "В неделю"
        case .month:
            return "В месяц"
        case .unlimit:
            return "Безлимит"
        }
    }
}
