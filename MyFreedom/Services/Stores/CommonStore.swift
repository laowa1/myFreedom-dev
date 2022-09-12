//
//  CommonStore.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

class CommonStore {
    
    var notificationToken: String?

    var customerId: Int?

    var customerExternalId: String?

    class var version: String? { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String }

    var build: String? { Bundle.main.infoDictionary?["CFBundleVersion"] as? String }

    var deviceId: String? { UIDevice.current.identifierForVendor?.uuidString }

    var systemVersion: String { UIDevice.current.systemVersion }
    
    weak var rootWindow: UIWindow?
    
    var lastCodeConfirmationSendDate: Date?
    
    let logger = BaseLogger()
    
    var codeConfirmationResendTime: TimeInterval {
        let secondsPassed = lastCodeConfirmationSendDate.map(Date().timeIntervalSince) ?? 0
        return secondsPassed < 60 ? 60 - secondsPassed : 60
    }
    
    init() {
        setDefaults()
    }
    
    private func setDefaults() {
        let keyValueStore = KeyValueStore()

        if keyValueStore.getValue(for: .theme) == String?.none {
            keyValueStore.set(value: Theme.default.rawValue, for: .theme)
        }

        if keyValueStore.getValue(for: .languageCode) == String?.none {
            keyValueStore.set(value: Language.default.code, for: .languageCode)
        }
    }
}
