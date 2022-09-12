//
//  TextFieldDelegate.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import Foundation

protocol TextFieldDelegate: TextValidatableDelegate {
    func didChange<ID>(text: String, forId id: ID)
    func didBeginEditing<ID>(text: String, forId id: ID)
    func didEndEditing<ID>(text: String, forId id: ID)
    func shouldBeginEditing<ID>(text: String, forId id: ID) -> Bool
    func shouldReturn<ID>(text: String, forId id: ID) -> Bool
}

extension TextFieldDelegate {
    func didChange<ID>(text: String, forId id: ID) {}
    func didBeginEditing<ID>(text: String, forId id: ID) {}
    func didEndEditing<ID>(text: String, forId id: ID) {}
    func shouldBeginEditing<ID>(text: String, forId id: ID) -> Bool { true }
    func shouldReturn<ID>(text: String, forId id: ID) -> Bool { true }
}


protocol TextValidatableDelegate: AnyObject {
    func validate<ID>(text: String, forId: ID)
    func allowCharacters<ID>(in text: String, forId id: ID) -> Bool
}

extension TextValidatableDelegate {
    func validate<ID>(text: String, forId: ID) {}
    func allowCharacters<ID>(in text: String, forId id: ID) -> Bool { true }
}
