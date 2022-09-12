//
//  YandexAnalyticsService.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 15.04.2022.
//

import YandexMobileMetrica

final class YandexManager {

    func initialize() {
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "7e83d35c-286e-43c2-a806-b52dc8c3c488")
        YMMYandexMetrica.activate(with: configuration!)
    }
    
    func logEvent(eventName: String, parameters: [String: Any]) {
        YMMYandexMetrica.reportEvent(eventName, parameters: parameters, onFailure: { error in
            print(error)
            print("DID FAIL REPORT EVENT: %@", eventName)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func logError(_ error: Error) {
        YMMYandexMetrica.report(nserror: error)
    }
    
    func set(_ property: String?, for key: UserProperty) {
        #if DEBUG

        #else
        let profile = YMMMutableUserProfile()
        profile.apply(YMMProfileAttribute.customString(key.rawValue).withValue(property))
        YMMYandexMetrica.report(profile, onFailure: { (error) in
            print("REPORT ERROR: %@", error.localizedDescription)
        })

        #endif
    }
}
