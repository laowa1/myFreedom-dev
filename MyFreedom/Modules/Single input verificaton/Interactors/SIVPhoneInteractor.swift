//
//  SIVPhoneInteractor.swift
//  MyFreedom
//
//  Created by Sanzhar on 16.03.2022.
//

import UIKit

final class SIVPhoneInteractor: SIVInteractorInput {
    var view: SIVViewInput?
    
    var id: UUID?
    
    var title: String = "Введите новый номер телефона"
    
    var placeholder: String = "+7"
    
    var keyboardType: UIKeyboardType = .phonePad
    
    var inputFieldMask: String = Constants.phoneMask
    
    var errorText: String = "Такой номер уже зарегистрирован"
    
    var textContentType: UITextContentType? {
        return .telephoneNumber
    }
 
    func validate(text: String) -> Bool {
        let phone = text.replacingOccurrences(of: " ", with: "")
        return phone.count == 12 && phone != "+77777777777"
    }
}
