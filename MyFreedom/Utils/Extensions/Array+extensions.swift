//
//  Array+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}

extension Array where Element == String? {

    func nonNilJoined(separator: String = "") -> String { compactMap { $0 } .joined(separator: separator) }
}

extension Sequence where Element: Hashable {

    /// Returns a sequence of unique values without losing order
    var unique: [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}
