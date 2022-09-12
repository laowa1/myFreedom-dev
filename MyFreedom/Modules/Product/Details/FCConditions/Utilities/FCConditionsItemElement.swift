//
//  FCConditionsItemElement.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import Foundation

enum FCConditionsFieldItemType: Equatable {
    case condition
    case terms
}
struct FCConditionsFieldItemElement {
    var title: String = ""
    var fieldType: FCConditionsFieldItemType
    var subtitle: String?
}
