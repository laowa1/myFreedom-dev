//
//  AuthorizationViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 01.04.2022.
//

import UIKit

protocol AuthorizationViewInput: BaseViewInput, BaseViewControllerProtocol {
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol)
}
