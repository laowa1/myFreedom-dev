//
//  PDLimitsRouterInput.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import Foundation

protocol PDLimitsRouterInput {
    
    func presentDetail()
    func presentBottomSheet(module: BaseDrawerContentViewControllerProtocol)
    func popViewContoller()
    func closeSession()
}
