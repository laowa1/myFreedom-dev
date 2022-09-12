//
//  TPAmountTextValidator.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//

import Foundation

class TPAmountTextValidator {

    let pattern = Optional("^[0-9]+\\.?[0-9]{0,2}$")

    let customRule: (_ text: String) -> Bool

    let range: ClosedRange<Decimal>?

    init() {
        self.customRule = { _ in true }
        self.range = nil
    }

    init(customRule: @escaping (_ text: String) -> Bool = { _ in true }) {
        self.customRule = customRule
        self.range = nil
    }

    init(range: ClosedRange<Decimal>? = nil) {
        self.range = range
        self.customRule = { _ in true }
    }

    func validateCharacters(in text: String) -> Bool {
        guard !text.isEmpty else { return true }

        let textToCheck = text.prefix(while: { $0 != "." })
        guard let number = Int(textToCheck),
              String(number) == textToCheck,
              textToCheck.count <= 10 else { return false }

        let validate = validateFormat(for: text)
        guard let range = range,
              let amount = Decimal(string: text) else {
            return validate
        }

        return validate && range ~= amount
    }
    
    private func validateFormat(for text: String) -> Bool {
        guard let pattern = pattern else { return true }

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
