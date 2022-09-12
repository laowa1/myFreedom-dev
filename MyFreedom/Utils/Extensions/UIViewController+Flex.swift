//
//  UIViewController+Flex.swift
//  MyFreedom
//
//  Created by m1pro on 08.04.2022.
//

import UIKit
#if DEBUG
import FLEX

extension UIViewController {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            FLEXManager.shared.showExplorer()
        }
    }
}
#endif
