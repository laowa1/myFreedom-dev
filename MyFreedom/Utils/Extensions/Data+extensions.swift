//
//  Data+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import Foundation

extension Data {

    var jsonString: String? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: self),
           let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) {
            return String(data: data, encoding: .utf8)
        }
        return String(data: self, encoding: .utf8)
    }
}
