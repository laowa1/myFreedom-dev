//
//  IINValidator.swift
//  litro.kz_service_ios
//
//  Created by m1pro on 01.03.2022.
//

import Foundation

class IINValidator {

    init() {}

    func isValid(_ text: String) -> Bool {
        let iin: [Int] = text.compactMap { Int(String($0)) }

        guard iin.count == 12 else { return false }

        switch iin[4] {
        case 0...3:
            let dateFormatterFromSM: DateFormatter = {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyMMdd"
                return dateFormatter
            }()

            let date = dateFormatterFromSM.date(from: String(text.replacingOccurrences(of: " ", with: "").prefix(6)))
            if date == nil { return false }
        case 4...6:
            break
        default:
            return false
        }

        let firstIINValidation =  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        let firstResult = zip(iin, firstIINValidation).map { $0 * $1 } .reduce(0, +)

        var checkDigit = firstResult % 11

        if checkDigit == 10 {
            let secondIINValidation =  [3, 4, 5, 6, 7, 8, 9, 10, 11, 1, 2]
            let secondResult = zip(iin, secondIINValidation).map { $0 * $1 } .reduce(0, +)

            checkDigit = secondResult % 11
        }

        guard checkDigit == iin[11] else { return false }

        return true
    }
}
