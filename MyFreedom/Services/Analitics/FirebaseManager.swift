//
//  FirebaseManager.swift
//  MyFreedom
//
//  Created by m1pro on 17.04.2022.
//

import Firebase
import FirebaseAnalytics
import FirebaseCrashlytics

final class FirebaseManager: FirebaseManagerProtocol {

    func initialize() {
        Analytics.initialize()
        Analytics.setAnalyticsCollectionEnabled(true)
        FirebaseApp.app()?.isDataCollectionDefaultEnabled = true
        #if DEBUG
        FirebaseConfiguration.shared.setLoggerLevel(.max)
        #endif
    }

    func logEvent(eventName: String, parameters: [String: Any]) {
        Analytics.logEvent(eventName, parameters: parameters)
    }

    func logError(_ error: NSError) {
        Crashlytics.crashlytics().record(error: error)
    }
}

class NonFatalError: NSError {
    static func wrongSMSCode(isLegacy: Bool) -> NonFatalError {
        return NonFatalError(kind: .wrongSmsCode,
                             code: 11111,
                             params: [.version: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""])
    }
    
    convenience init(kind: Kind, code: Int, params: [ParameterKey: String]) {
        self.init(domain: kind.rawValue, code: code, userInfo: params.mapKeys { $0.rawValue })
    }
    
    enum ParameterKey: String {
        case version
    }
    
    enum Kind: String {
        case wrongSmsCode = "wrong_sms_code_entered"
    }
}

// TODO: move to Core module when there is one
extension Dictionary {
    func mapKeys<NewKey>(transform: (Key) -> NewKey) -> [NewKey: Value] where NewKey: Hashable {
        var pairs: [NewKey: Value] = [:]
        for key in keys {
            pairs[transform(key)] = self[key]
        }
        return pairs
    }
}
