//
//  OpenInvestCardItemType.swift
//  MyFreedom
//
//  Created by &&TairoV on 30.06.2022.
//
import Foundation
import UIKit

enum OpenInvestCardTable {
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
        var elements: OpenInvestCardSection = []
        var isExpand: Bool = false
    }
}

typealias OpenInvestCardSection = [OpenInvestCardFieldItemElement]

enum OpenInvestCardFieldItemType: Equatable {
    case card
    case features
    case rate
    case rateInfo
    case button
}

struct OpenInvestCardFieldItemElement {
    var image: UIImage?
    var title: String = ""
    var fieldType: OpenInvestCardFieldItemType
    var description: String?
}
