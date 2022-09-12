//
//  Builder.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

public func build<T>(_ object: T, builder: (T) -> Void) -> T {
    builder(object)
    return object
}

/** Simplifies building NSObject

   Old example

       private var amountLabel: UILabel = {
           let label = UILabel()
           label.font = .systemFont(ofSize: 17, weight: .semibold)
           label.textColor = AlfaUIColorPalette.textPrimary.color
           return label
       }()

   vs new example

       private let amountLabelNew: UILabel = build {
           $0.font = .systemFont(ofSize: 17, weight: .semibold)
           $0.textColor = AlfaUIColorPalette.textPrimary.color
       }
*/
public func build<T: NSObject>(builder: (T) -> Void) -> T {
    build(T.init(), builder: builder)
}
