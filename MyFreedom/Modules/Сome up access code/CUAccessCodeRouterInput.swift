//
//  CUAccessCodeRouterInput.swift
//  MyFreedom
//
//  Created by m1pro on 16.05.2022.
//

import Foundation

protocol CUAccessCodeRouterInput: AnyObject {
    
    func routeToBack()
    func routeToRepeat(code: String, popToRoot: Bool, type: CUAccessCodeType)
    func routeToInform(deledate: InformPUButtonDelegate, model: InformPUViewModel)
    func login()
    func closeSession()
}
