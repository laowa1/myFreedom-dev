//
//  SIVIinInteractor.swift
//  MyFreedom
//
//  Created by Sanzhar on 16.03.2022.
//

import UIKit

final class SIVIinInteractor: SIVInteractorInput {
    var view: SIVViewInput?
    
    var id: UUID?
    
    var title: String = "Введите ваш ИИН"
    
    var placeholder: String = "Ваш ИИН"
    
    var keyboardType: UIKeyboardType = .numberPad
    
    var errorText: String = "Некорректный ИИН, попробуйте еще раз"
    
    var inputFieldMask: String = Constants.idMask
 
    func validate(text: String) -> Bool {
        return IINValidator().isValid(text)
    }
}
