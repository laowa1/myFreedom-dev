//
//  UISearchBar+Extensions.swift
//  MyFreedom
//
//  Created by &&TairoV on 05.07.2022.
//

import UIKit

extension UISearchBar {
    var textField: UITextField {
        return self.value(forKey: "searchField") as! UITextField
    }
}
