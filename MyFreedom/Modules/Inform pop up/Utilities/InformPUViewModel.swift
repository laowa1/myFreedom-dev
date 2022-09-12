//
//  InformPUViewModel.swift
//  MyFreedom
//
//  Created by Sanzhar on 15.03.2022.
//

import UIKit

struct InformPUViewModel {
    let titleText: NSAttributedString
    let subtitleText: String
    let image: BaseImage
    let buttons: [InformPUButton]
    var hiddenBack = false
    var id: UUID?
    var url: String? = nil
    var urlTitle: String? = nil
}
