//
//  JCLBPLInteractorInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 08.07.2022.
//

import Foundation

protocol JCLBPLInteractorInput {
    
    func passPayments(_ payments: [JCLPayments])
    func getSectionCount() -> Int
    func getBlockedPayments() -> [JCLPayments]
    func getBlockedPaymet(at index: Int) -> JCLPayments?
    func getSection(at index: Int) -> JCLBPSections?
    func focusEditing(_ isEditing: Bool)
    func isFocusEditing() -> Bool
    func deletePayment(at index: Int)
}
