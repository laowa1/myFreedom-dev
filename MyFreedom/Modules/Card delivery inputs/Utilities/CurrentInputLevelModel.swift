//
//  CurrentInputLevelModel.swift
//  MyFreedom
//
//  Created by Sanzhar on 28.06.2022.
//

import UIKit

typealias OPTextFieldId = OrderPlasticCardViewController.TextFieldId

class CurrentInputLevelModel {
    let title: String
    let placeHolder: String
    let keyboardType: UIKeyboardType
    var value: String = ""
    let id: OPTextFieldId
    
    init(title: String, placeHolder: String, keyboardType: UIKeyboardType = .default, id: OPTextFieldId) {
        self.title = title
        self.placeHolder = placeHolder
        self.keyboardType = keyboardType
        self.id = id
    }
}
