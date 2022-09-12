//
//  BottomSheetPickerItem.swift
//  MobileBanking-KassanovaBank
//
//  Created by bnazhdev on 29.09.2021.
//

import UIKit

struct BasePickerPickerItem: BottomSheetPickerItemProtocol {
    var image: UIImage?
    let title: String
    var description: String? = nil
    var isSelected: Bool = false
    var accessoryImage: UIImage?
}
