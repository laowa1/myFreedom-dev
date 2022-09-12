//
//  BiometricType.swift
//  MyFreedom
//
//  Created by m1pro on 05.04.2022.
//

import Foundation

enum BiometricType {

    case none
    case touch
    case face
    case unowned

    var title: String {
        switch self {
        case .none, .unowned: return ""
        case .face: return "скану лица"
        case .touch: return "отпечатку пальца"
        }
    }
    
    var name: String {
        switch self {
        case .none, .unowned: return ""
        case .face: return "Face ID"
        case .touch: return "Touch ID"
        }
    }

    var icon: BaseImage? {
        switch self {
        case .none, .unowned: return nil
        case .face: return .faceId
        case .touch: return .fingerprintScan
        }
    }
}
