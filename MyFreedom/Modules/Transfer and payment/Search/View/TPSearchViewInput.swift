//
//  TPSearchViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import UIKit.UISearchController

protocol TPSearchViewInput: BaseViewControllerProtocol, UISearchBarDelegate, UISearchResultsUpdating {
    
    func reload()
}
