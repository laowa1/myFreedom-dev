//
//  Theme.swift
//  MyFreedom
//
//  Created by m1pro on 15.05.2022.
//

import Foundation

enum Theme: String, CaseIterable {

    case light, dark, system

    static var `default`: Theme { .light }
}
