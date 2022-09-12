//
//  ParentRouterInput.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 28.03.2022.
//

import Foundation

protocol ParentRouterInput: AnyObject {

    func pass(_ object: Any)
}

extension ParentRouterInput {

    func pass(_ object: Any) {}
}
