//
//  JCPresentationItemType.swift
//  MyFreedom
//
//  Created by &&TairoV on 30.06.2022.
//
import Foundation
import UIKit

enum JCPersentationTable {
    enum Id: Equatable {
        case card
        case features
        case rates
        case button
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: JCPersentationSection = []
        var isExpand: Bool = false
    }
}

typealias JCPersentationSection = [JCPersentationFieldItemElement]

enum JCPersentationFieldItemType: Equatable {
    case card
    case features
    case rate
    case rateInfo
    case button
}

struct JCPersentationFieldItemElement {
    var image: UIImage?
    var title: String = ""
    var fieldType: JCPersentationFieldItemType
    var description: String?
}
