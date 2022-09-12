//
//  BlockedPaymentsDelegate.swift
//  MyFreedom
//
//  Created by Sanzhar on 11.07.2022.
//

import Foundation

protocol BlockedPaymentsDelegate {
    func passSelectedPayments(_ payments: [JCLPayments])
}
