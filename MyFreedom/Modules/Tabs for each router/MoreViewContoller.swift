//
//  MoreViewContoller.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

class MoreViewContoller: BaseViewController { }

extension MoreViewContoller:  BaseTabBarPresentable {

    var baseTabBarItem: BaseTabBarItem {
        let tabBarItem = BaseTabBarItem()
        title = "Еще"
        tabBarItem.title = title
        tabBarItem.icon = BaseImage.more.uiImage
        return tabBarItem
    }
}
