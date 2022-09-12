//
//  Decimal+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import Foundation

extension Decimal {

    var visableAmount: String? {
        let number = NSDecimalNumber(decimal: self)
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: number)
    }
    
    func round(toPlaces decimalPlaces: Int) -> Decimal {
        var value = self
        var rounded = Self()
        NSDecimalRound(&rounded, &value, decimalPlaces, .bankers)
        return rounded
    }
}
