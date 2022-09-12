//
//  InformPopUpRouterInput.swift
//  MyFreedom
//
//  Created by Sanzhar on 15.03.2022.
//

import Foundation

protocol InformPopUpRouterInput {
    func buttonAction(type: InformPUButtonType, id: UUID)
    func routeToBack()
    func routeToWebview(title: String, url: URL)
}
