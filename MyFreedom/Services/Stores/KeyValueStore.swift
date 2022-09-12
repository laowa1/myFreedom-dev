//
//  KeyValueStore.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import Foundation

class KeyValueStore {

    enum Key: String {
        case firstLaunch
        case useBiometryToUnlock
        case usePasscodeToUnlock
        
        case languageCode
        case theme
        
        case enablePush, enableGeo
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func getValue<T>(for key: Key) -> T? { userDefaults.value(forKey: key.rawValue) as? T }

    func set<T>(value: T, for key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    func removeValue(for key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    func sync() {
        userDefaults.synchronize()
    }
}
