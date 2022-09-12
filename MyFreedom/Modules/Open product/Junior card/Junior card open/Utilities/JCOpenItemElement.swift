//
//  JCOpenItemElement.swift
//  MyFreedom
//
//  Created by &&TairoV on 04.07.2022.
//

import UIKit

enum JCOpenTable {
    
    enum Id: Equatable {
        case children
    }

    struct Section {
        let id: Id
        var title: String? = nil
        var footer: String? = nil
        var elements: JCOpenSection = []
    }
}

typealias JCOpenSection = [JCOpenFieldItemElement]

enum JCOpenFieldItemType: Equatable {
    case name
    case phoneNumber
}

struct JCOpenFieldItemElement {
    var image: UIImage?
    var title: String = ""
    var fieldType: JCOpenFieldItemType
    var description: String?
    var value: String?
}
