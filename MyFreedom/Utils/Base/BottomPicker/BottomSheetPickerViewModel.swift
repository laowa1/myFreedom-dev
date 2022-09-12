//
//  BottomSheetPickerViewModel.swift
//  MobileBanking-KassanovaBank
//
//  Created by bnazhdev on 18.10.2021.
//

import Foundation

struct BottomSheetPickerViewModel {
    let title: String?
    let id: UUID?
    let selectedIndex: Int
    let hideCloseButton: Bool = true
    let items: [BottomSheetPickerItemProtocol]
    weak var delegate: BottomSheetPickerViewDelegate?
}
