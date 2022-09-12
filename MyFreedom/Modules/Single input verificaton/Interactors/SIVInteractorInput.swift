//
//  SIVInteractorInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 16.03.2022.
//

import UIKit

protocol SIVInteractorInput {
    var view: SIVViewInput? { get set }
    var id: UUID? { get set }
    var title: String { get }
    var placeholder: String { get }
    var keyboardType: UIKeyboardType { get }
    var inputFieldMask: String { get }
    var errorText: String { get set }
    var textContentType: UITextContentType? { get }
    
    func validate(text: String) -> Bool
}

extension SIVInteractorInput {
    var textContentType: UITextContentType? {
        return nil
    }
}
