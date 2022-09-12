//
//  JCLBPLRouterInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 08.07.2022.
//

import Foundation

protocol JCLBPLRouterInput {
    
    func routeToBlockedPaymentSelection(payments: [JCLPayments]?)
}
