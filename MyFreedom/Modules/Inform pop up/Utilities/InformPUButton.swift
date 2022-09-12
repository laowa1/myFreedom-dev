//
//  InformPUButton.swift
//  MyFreedom
//
//  Created by Sanzhar on 11.03.2022.
//

import Foundation

protocol InformPUButtonDelegate: AnyObject {
    func buttonPressed(type: InformPUButtonType, id: UUID)
}

enum InformPUButtonType: Int {
    case confirm, cancel, destructive
}

struct InformPUButton {
    let type: InformPUButtonType
    let title: String
    let isGreen: Bool
    
    static var nextButton = InformPUButton(type: .confirm, title: "Продолжить", isGreen: true)
}
