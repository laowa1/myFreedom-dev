//
//  CustomSearchContoller.swift
//  MyFreedom
//
//  Created by m1 on 03.07.2022.
//

import UIKit

class CustomSearchContoller: UISearchController, BaseViewControllerProtocol {

    var baseModalPresentationStyle: UIModalPresentationStyle { .custom }

    var baseModalTransitionStyle: UIModalTransitionStyle { modalTransitionStyle }

    var topAlertView: UIView?

    var popUpWindow: UIWindow?
}
