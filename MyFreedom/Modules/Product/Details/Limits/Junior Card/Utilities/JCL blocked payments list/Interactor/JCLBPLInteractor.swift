//
//  JCLBPLInteractor.swift
//  MyFreedom
//
//  Created by Sanzhar on 08.07.2022.
//

import Foundation

class JCLBPLInteractor {
    
    private var view: JCLBPLViewInput
    private var blockedPayments = [JCLPayments]()
    
    private var section = JCLBPSections.allCases
    private var focusEditing: Bool = false
    
    init(view: JCLBPLViewInput) {
        self.view = view
    }
}

extension JCLBPLInteractor: JCLBPLInteractorInput {
    
    func passPayments(_ payments: [JCLPayments]) {
        blockedPayments = payments
        view.updateTableView()
    }
    
    func getSectionCount() -> Int {
        return blockedPayments.count > 0 ? section.count : 2
    }
    
    func getBlockedPayments() -> [JCLPayments] {
        return blockedPayments
    }
    
    func getBlockedPaymet(at index: Int) -> JCLPayments? {
        return blockedPayments[safe: index]
    }
    
    func getSection(at index: Int) -> JCLBPSections? {
        return section[safe: index]
    }
    
    func focusEditing(_ isEditing: Bool) {
        focusEditing = isEditing
        
        if isEditing {
            section.removeAll { $0 != .blockedPayments }
        } else {
            section = JCLBPSections.allCases
        }
        
        view.updateTableView()
    }
    
    func isFocusEditing() -> Bool {
        return focusEditing
    }
    
    func deletePayment(at index: Int) {
        blockedPayments.remove(at: index)
    }
}
