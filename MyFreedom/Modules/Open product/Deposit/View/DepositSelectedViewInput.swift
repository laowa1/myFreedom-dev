//
//  DepositSelectedViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import UIKit.UISearchController

protocol DepositSelectedViewInput: BaseViewController {

    func pass(segmentTitles: [String])
    func reload()
}
