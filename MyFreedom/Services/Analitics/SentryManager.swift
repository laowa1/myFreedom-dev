//
//  SentryManager.swift
//  MyFreedom
//
//  Created by m1pro on 17.04.2022.
//

import Sentry

final class SentryManager {
    
    func initialize() {
        let environment: String
        let isDebug: Bool
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String,
           configuration == "Release" {
            environment = "production"
            isDebug = false
        } else {
            environment = "stage"
            isDebug = true
        }
        SentrySDK.start(options: ["dsn": "https://4b35072848b54ec3bfc7731acd6cba0b@o1208688.ingest.sentry.io/6345758",
                                  "debug": isDebug,
                                  "release": CommonStore.version ?? "",
                                  "environment": environment,
                                  "enableAutoSessionTracking": true,
                                  "sessionTrackingIntervalMillis": 60000,
                                  "integrations": Sentry.Options.defaultIntegrations().filter { (name) -> Bool in
                                    return name != "SentryAutoBreadcrumbTrackingIntegration" // This will disable  SentryAutoBreadcrumbTrackingIntegration
            }])
    }
     
    func errorCapture(message: String, code: String = "", extra: [String:Any] = [:], type: SentryLevel = .error) {
        let event = Sentry.Event(level: type)
        event.message = SentryMessage(formatted: message + " Code if exist: \(code)")
        event.extra = extra
        SentrySDK.capture(event: event)
    }
    
    // network and db errors
    static func breadcrumbCapture(type: SentryLevel = .info, message: String) {
        let bread = Breadcrumb(level: .info, category: "Breadcrumb")
        bread.data = ["message":message]
        SentrySDK.addBreadcrumb(crumb: bread)
    }
}
