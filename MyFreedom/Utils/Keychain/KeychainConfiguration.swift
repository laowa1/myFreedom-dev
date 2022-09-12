//
//  KeychainConfiguration.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 04.04.2022.
//

import Foundation

struct KeychainConfiguration {

    private enum Key: String {

        // keychain service key
        case keychainService

        // raw username
        case QY163TA67NB5S2G93YG35K03YJV2P36K

        // username key
        case QK8X845Z6T02U9G78FQG3IP2F6GG12J3

        // password key
        case KBBI6UMN1TH58VX62S53619K382HB1V7

        // passcode key
        case F22R9E34K53WZWQJ1W2090Z7ED9DGO89
    }

    static let serviceName = (Bundle.main.bundleIdentifier ?? "") + "." + Key.keychainService.rawValue
    static let accessGroup = String?.none
    static var rawUsernameKey: String { Key.QY163TA67NB5S2G93YG35K03YJV2P36K.rawValue }
    static var usernameKey: String { Key.QK8X845Z6T02U9G78FQG3IP2F6GG12J3.rawValue }
    static var passwordKey: String { Key.KBBI6UMN1TH58VX62S53619K382HB1V7.rawValue }
    static var passcodeKey: String { Key.F22R9E34K53WZWQJ1W2090Z7ED9DGO89.rawValue }
}
