//
//  JCLBPSInteracor.swift
//  MyFreedom
//
//  Created by Sanzhar on 06.07.2022.
//

import Foundation

class JCLBPSInteractor {
    
    private var view: JCLBPSViewInput
    private let delegate: BlockedPaymentsDelegate
    private let paymentsList = JCLPayments.allCases
    private var savedPayments: [JCLPayments]
    private lazy var selectedPayments = savedPayments
    private var allPaymentsAreSelected: Bool = false
    
    init(view: JCLBPSViewInput, delegate: BlockedPaymentsDelegate, payments: [JCLPayments]) {
        self.view = view
        self.savedPayments = payments
        self.delegate = delegate
    }
    
    private func deselectPayment(at index: Int) {
        let payment = paymentsList[index]
        selectedPayments.removeAll { $0 == payment }
    }
}

extension JCLBPSInteractor: JCLBPSInteractorInput {
    
    func getPaymentsList() -> [JCLPayments] {
        return paymentsList
    }
    
    func getPaymentFromList(at index: Int) -> JCLPayments {
        return paymentsList[index]
    }
    
    func getSelectedPayments() -> [JCLPayments] {
        return selectedPayments
    }
    
    func selectPayment(at index: Int) {
        guard let payment = paymentsList[safe: index] else { return }
        
        if allPaymentsAreSelected { //&& selectedPayments.contains(payment) {
            allPaymentsAreSelected = false
        }
        
        if !selectedPayments.contains(payment) {
            selectedPayments.append(payment)
        } else if selectedPayments.contains(payment) {
            selectedPayments.removeAll { $0 == payment }
        }
    }
    
    func paymentIsSelected(at index: Int) -> Bool {
        return selectedPayments.contains(paymentsList[index])
    }
    
    func getSelectedPayment(at index: Int) -> JCLPayments? {
        return selectedPayments[safe: index]
    }
    
    func toggleAllPaymentsAreSelected() {
        allPaymentsAreSelected.toggle()
        if allPaymentsAreSelected {
            selectedPayments = paymentsList
        } else {
            selectedPayments = []
        }
        view.updateTableView()
    }
    
    func getFinishedSelection() -> [JCLPayments] {
        savedPayments = selectedPayments
        return savedPayments
    }
    
    func getSavedPayments() -> [JCLPayments] {
        return savedPayments
    }
    
    func passPayments() {
        delegate.passSelectedPayments(savedPayments)
    }
}
