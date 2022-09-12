//
//  BaseLogger.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 15.04.2022.
//

import FirebaseAnalytics
import FirebaseCrashlytics
import YandexMobileMetrica
import AppsFlyerLib

enum UserProperty: String {
    case app_language
    case app_theme
}

class BaseLogger {
    
    let firebaseManager: FirebaseManagerProtocol = FirebaseManager()
    let appsFlyerManager: AppsFlyerManagerProtocol = AppsFlyerManager()
    let sentryManager = SentryManager()
    let yandexManager = YandexManager()
    
    func initalize(id: String?) {
        firebaseManager.initialize()
        appsFlyerManager.initialize()
        sentryManager.initialize()
        yandexManager.initialize()
        
        if #available(iOS 14.5, *) {
            appsFlyerManager.waitForATTUserAuthorization(timeout: 60.0)
        }
        
        setUserID(id)
    }
    
    func didBecomeActive() {
        appsFlyerManager.startAppsFlyer()
    }
    
    func sendAnalyticsEvent(event: String, with parameters: [String: Any]) {
        #if DEBUG

        #else
        firebaseManager.logEvent(eventName: event, parameters: parameters)
        appsFlyerManager.logEvent(eventName: event, eventValues: parameters, completionHandler: nil)
        yandexManager.logEvent(eventName: event, parameters: parameters)
        #endif
    }
    
    // change send custom error
    func sendErrorEvent(message: String) {
        #if DEBUG

        #else
        firebaseManager.logError(NSError(domain: message, code: 1))
        sentryManager.errorCapture(message: message)
        yandexManager.logError(NSError(domain: message, code: 1))
        #endif
    }
    
    func sendScreenEvent(for screenName: String) {
        #if DEBUG
        
        #else
        firebaseManager.logEvent(eventName: "screen_view", parameters: ["screen_name": screenName])
        appsFlyerManager.logEvent(eventName: "screen_view", eventValues: ["screen_name": screenName], completionHandler: nil)
        yandexManager.logEvent(eventName: "screen_view", parameters: ["screen_name": screenName])
        #endif
    }
    
    func setUserProperty(_ property: String?, for key: UserProperty) {
        Analytics.setUserProperty(property, forName: key.rawValue)
        yandexManager.set(property, for: key)
    }
    
    private func setUserID(_ id: String?) {
        #if DEBUG
        
        #else
        if let id = id {
            Crashlytics.crashlytics().setUserID(id)
        }
        Analytics.setUserID(id)
        YMMYandexMetrica.setUserProfileID(id)
        #endif
    }
}

//import AppTrackingTransparency
    /// Starting iOS 14.5, IDFA access is governed by the ATT framework.
    /// Enabling ATT support in the SDK handles IDFA collection on devices with iOS 14.5+ installed.
//    private func requestTrackingAuthorization() {
//        if #available(iOS 14.5, *) {
//            ATTrackingManager.requestTrackingAuthorization { (status) in
//                if status != .authorized {
//                    YMMYandexMetrica.setStatisticsSending(false)
//                    YMMYandexMetrica.setLocationTracking(false)
//                }
//            }
//        }
//    }
//}
