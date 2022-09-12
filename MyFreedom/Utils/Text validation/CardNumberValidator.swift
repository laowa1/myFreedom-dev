//
//  CardNumberValidator.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import Foundation

final class CardNumberValidator: NSObject {

    // Luhn algorithm
    func isValid(_ text: String) -> Bool {
        guard !text.isEmpty, text.count == 16 else { return false }

        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text)) { return false }

        var sum = 0
        let digitStrings = text.reversed().map { String($0) }

        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1

                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        return sum % 10 == 0
    }

    func isMatchingVisaCard(_ text: String) -> Bool {
        return text.prefix(1) == "4"
    }

    func isMatchingMasterCard(_ text: String) -> Bool {
        let pattern = "^5[1-5][0-9]{0,14}"

        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch {
            return false
        }

        let range = NSRange(location: 0, length: text.count)
        return regex.firstMatch(in: text, range: range) != nil
    }
}
