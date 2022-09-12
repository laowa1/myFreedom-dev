//
//  ChatViewContoller.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

class ChatViewContoller: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension ChatViewContoller:  BaseTabBarPresentable {

    var baseTabBarItem: BaseTabBarItem {
        let tabBarItem = BaseTabBarItem()
        title = "Чат"
        tabBarItem.title = title
        tabBarItem.icon = BaseImage.chat.uiImage
        return tabBarItem
    }
}
