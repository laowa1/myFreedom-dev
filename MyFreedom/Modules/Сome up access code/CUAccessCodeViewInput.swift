//
//  CUAccessCodeViewInput.swift
//  MyFreedom
//
//  Created by m1pro on 16.05.2022.
//

import UIKit.UIColor

protocol CUAccessCodeViewInput: BaseViewController {

    func set(with dotsColors: [UIColor])
    func routeToRepeat(code: String, popToRoot: Bool, type: CUAccessCodeType)
    func routeToInform(deledate: InformPUButtonDelegate, model: InformPUViewModel)
    func login()
    func closeSession()
}
