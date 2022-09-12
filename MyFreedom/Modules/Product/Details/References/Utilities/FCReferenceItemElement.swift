//
//  Fcreferenceitemelement.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit

typealias FCReferenceSection = [FCReferenceFieldItemElement]

enum FCReferenceTable {
    enum Id: Equatable {
        case reference
        case language
        case period
        case button
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var selectedIndex: Int = -1
        var elements: FCReferenceSection = []
    }
}

struct FCReferenceFieldItemElement {
    var image: UIImage? = nil
    var title: String
    var subtitle: String? = nil
    var caption: String? = nil
    var accessory: UIImage? = BaseImage.chevronRight.uiImage
    var filedType: FCReferenceItemFiledType
}

enum FCReferenceItemFiledType: Equatable {
    case reference
    case language
    case period
    case selectPeriod
}
