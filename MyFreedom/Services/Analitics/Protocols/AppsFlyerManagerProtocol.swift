//
//  AppsFlyerManagerProtocol.swift
//  MyFreedom
//
//  Created by m1pro on 17.04.2022.
//

import Foundation
import UIKit.UIApplication

protocol AppsFlyerManagerProtocol: AnyObject {
    func initialize()
    func waitForATTUserAuthorization(timeout: TimeInterval)
    func startAppsFlyer()
    func handlePushNotification(userInfo: [AnyHashable: Any])
    func continueUserActivity(_ userActivity: NSUserActivity, restorationHandler: (([Any]?) -> Void)?)
    func handleOpenURL(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any])
    func handleOpenURL(_ url: URL, sourceApplication: String?, annotation: Any)
    func logEvent(eventName: String, eventValues: [String : Any]?, completionHandler: (([String: Any]?, Error?) -> Void)?)
}
