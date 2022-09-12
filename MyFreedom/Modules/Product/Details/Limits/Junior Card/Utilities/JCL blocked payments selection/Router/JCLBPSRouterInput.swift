//
//  JCLBPRouterInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 06.07.2022.
//

import Foundation

protocol JCLBPSRouterInput {
    
    func routeToBack(payments: [JCLPayments])
    func cancelToBack(payments: [JCLPayments])
}
