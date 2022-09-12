//
//  UIDevice+extensions.swift
//  MyFreedom
//
//  Created by Sanzhar on 18.03.2022.
//

import UIKit

extension UIDevice {
    var iPhone: Bool {
        // swiftlint:disable discouraged_direct_init
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case iPhoneXR
        case iPhoneXSMax
        case iPhone12Pro
        case iPhone12ProMax
        case unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 1792:
            return .iPhoneXR
        case 1920, 2208:
            return .iPhone6Plus
        case 2436:
            return .iPhoneX
        case 2532:
            return .iPhone12Pro
        case 2688:
            return .iPhoneXSMax
        case 2778:
            return .iPhone12ProMax
        default:
            return .unknown
        }
    }
    
    var isSmallScreen: Bool {
        let screenType = UIDevice.current.screenType
        return  screenType == .iPhone6 || screenType == .iPhone5 || screenType == .iPhone4
    }
    
    var isIOS12: Bool {
        let os = ProcessInfo().operatingSystemVersion
        return os.majorVersion == 12
    }
}

extension OperatingSystemVersion {
    func getFullVersion(separator: String = ".") -> String {
        return "\(majorVersion)\(separator)\(minorVersion)\(separator)\(patchVersion)"
    }
}


extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }

}
