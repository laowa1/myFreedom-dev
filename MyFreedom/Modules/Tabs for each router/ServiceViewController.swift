//
//  ServiceViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

class ServiceViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension ServiceViewController:  BaseTabBarPresentable {

    var baseTabBarItem: BaseTabBarItem {
        let tabBarItem = BaseTabBarItem()
        title = "Сервисы"
        tabBarItem.title = title
        tabBarItem.icon = BaseImage.service.uiImage
        return tabBarItem
    }
}
