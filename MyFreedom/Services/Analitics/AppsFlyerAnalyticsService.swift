//
//  AppsFlyerAnalyticsService.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 15.04.2022.
//

import UIKit.UIApplication
import AppsFlyerLib

final class AppsFlyerManager: NSObject, AppsFlyerManagerProtocol {
  
    func initialize() {
        AppsFlyerLib.shared().appsFlyerDevKey = "xFLRiERKEyWvFYUhg93o3n"
        AppsFlyerLib.shared().appleAppID = "1619733462"
        AppsFlyerLib.shared().deepLinkDelegate = self
        #if DEBUG
            AppsFlyerLib.shared().delegate = self
            AppsFlyerLib.shared().isDebug = true
        #endif
    }
    
    func waitForATTUserAuthorization(timeout: TimeInterval) {
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: timeout)
    }
    
    func startAppsFlyer() {
        AppsFlyerLib.shared().start()
    }
    
    func handlePushNotification(userInfo: [AnyHashable: Any]) {
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    
    func continueUserActivity(_ userActivity: NSUserActivity, restorationHandler: (([Any]?) -> Void)?) {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: restorationHandler)
    }
    
    func handleOpenURL(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) {
        AppsFlyerLib.shared().handleOpen(url, options: options)
    }
    
    func handleOpenURL(_ url: URL, sourceApplication: String?, annotation: Any) {
        AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
    }
    
    func logEvent(eventName: String, eventValues: [String : Any]? = nil, completionHandler: (([String: Any]?, Error?) -> Void)? = nil) {
        AppsFlyerLib.shared().logEvent(name: eventName, values: eventValues, completionHandler: completionHandler)
    }
}

extension AppsFlyerManager: DeepLinkDelegate {
    
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .found:
            if let deeplinkValue = result.deepLink?.deeplinkValue,
               let url = URL(string: deeplinkValue) {
                print(url)
            }
        case .notFound:
            print("Deep link not found")
        case .failure:
            print("Error", result.error!)
        }
    }
}

// Attention!
// If you don't use conversion data for purposes other than testing,
// make sure to remove AppsFlyerLibDelegate when releasing your app to production.
extension AppsFlyerManager: AppsFlyerLibDelegate {
    
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        print("onConversionDataSuccess data:")
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let isFirstLaunch = installData["is_first_launch"] as? Bool,
               isFirstLaunch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        print(error)
    }
    
    // Обработка Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":", value)
        }
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
    }
}
