//
//  JCLBPSInteractorInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 06.07.2022.
//

import Foundation

protocol JCLBPSInteractorInput {
    
    func getPaymentsList() -> [JCLPayments]
    func getPaymentFromList(at index: Int) -> JCLPayments
    func getSelectedPayments() -> [JCLPayments]
    func getSelectedPayment(at index: Int) -> JCLPayments?
    func selectPayment(at index: Int)
    func paymentIsSelected(at index: Int) -> Bool
    func toggleAllPaymentsAreSelected()
    func getFinishedSelection() -> [JCLPayments]
    func getSavedPayments() -> [JCLPayments]
    func passPayments()
}
