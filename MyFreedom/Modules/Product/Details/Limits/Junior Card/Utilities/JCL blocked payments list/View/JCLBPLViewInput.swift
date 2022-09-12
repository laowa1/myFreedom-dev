//
//  JCLBPLViewInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 08.07.2022.
//

import Foundation

protocol JCLBPLViewInput: BaseViewController {
    
    func passPayments(_ payments: [JCLPayments])
    func updateTableView()
}
