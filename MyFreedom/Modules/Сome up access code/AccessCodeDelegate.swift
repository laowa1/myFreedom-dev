//
//  AccessCodeDelegate.swift
//  MyFreedom
//
//  Created by m1pro on 16.05.2022.
//

import Foundation

protocol AccessCodeDelegate: AnyObject { }

protocol AccessCodeConfirmFaceDelegate: AccessCodeDelegate {
    func confirmFace()
}

protocol AccessCodeChangeDelegate: AccessCodeDelegate {
    func confirmChange()
}
