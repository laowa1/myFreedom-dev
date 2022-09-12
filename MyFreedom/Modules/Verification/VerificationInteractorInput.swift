//
//  VerificationInteractorInput.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 28.03.2022.
//

import Foundation

protocol VerificationInteractorInput: AnyObject {
    
    func getId() -> UUID
    func getPhone() -> String
    func getType() -> VerificationType
    func invalidateTimer()
    func setPhoneNumber()
    func setResendTime()
    func runTimer()
}
