//
//  BaseTabBarPresentable.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

protocol BaseTabBarPresentable where Self: UIViewController {
    
    var baseTabBarItem: BaseTabBarItem { get }
}
