//
//  CUAccessCodeType.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 17.03.2022.
//

import Foundation

enum CUAccessCodeType: Equatable {
    case comeUp
    case `repeat`
    case confirmFace(type: String)
    
    case change, new, repeatNew
    
    var title: String {
        switch self {
        case .comeUp:
            return "Придумайте код доступа"
        case .repeat:
            return "Повторите код доступа"
        case .confirmFace(let type):
            return "Вход с \(type)"
        case .change:
            return "Изменить код доступа"
        case .new:
            return "Введите новый код доступа"
        case .repeatNew:
            return "Повторите новый код доступа"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .comeUp, .repeat:
            return "Для быстрого входа в приложение"
        case .confirmFace, .change:
            return "Введите текущий код доступа"
        case .new, .repeatNew:
            return nil
        }
    }
}
