//
//  String+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import Foundation

extension String {
    
    var amount: Decimal? {
        let string = replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")
        guard Double(string) != nil else { return nil }
        return Decimal(string: string)
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    func date(withFormat dateFormat: Date.Format) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.string
        return dateFormatter.date(from: self)
    }
    
    var localized: String {
        get {
            var lang = "ru"
            if let code: String = KeyValueStore().getValue(for: .languageCode) {
                lang = code
            }
            
            guard let path = Bundle.main.path(forResource: lang, ofType: "lproj") else { return self }
            let bundle = Bundle(path: path)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        }
    }

    subscript(r: Range<Int>) -> String? {
        let stringCount = self.count
        if (stringCount < r.upperBound) || (stringCount < r.lowerBound) {
            return nil
        }
        let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = index(self.startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[(startIndex ..< endIndex)])
    }

    func containsAlphabets() -> Bool {
        // Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains( where: {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        })
    }

    var isNumeric: Bool {
      return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    }
}
