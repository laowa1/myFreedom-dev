//
//  BaseImageProtocol.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit

protocol BaseImageProtocol {
    
    var rawValue: String { get }
    
    var bundle: Bundle { get }
}

extension BaseImageProtocol {
    
    var uiImage: UIImage? {
        return UIImage(named: rawValue, in: bundle, compatibleWith: nil)
    }

    var template: UIImage? {
        return uiImage?.withRenderingMode(.alwaysTemplate)
    }

    func uiImage(tintColor: UIColor) -> UIImage? { uiImage?.withTintColor(tintColor) }

    var cgImage: CGImage? {
        return uiImage?.cgImage
    }
}

class BaseImage: RawRepresentable, Equatable {
    
    typealias RawValue = String
    
    let rawValue: RawValue
    
    let bundle: Bundle
    
    required init?(rawValue: String) { fatalError("Not implemented") }
    
    required init(rawValue: String = #function, from bundle: Bundle = .init(for: BaseImage.self)) {
        self.rawValue = rawValue
        self.bundle = bundle
    }
}

extension BaseImage: BaseImageProtocol {
    static var logoBig: BaseImage { .init() }
    static var close: BaseImage { .init() }
    static var warning: BaseImage { .init() }
    static var back: BaseImage { .init() }
    static var document: BaseImage { .init() }
    static var clear: BaseImage { .init() }
    static var hintError: BaseImage { .init() }
    static var hintInformation: BaseImage { .init() }
    static var onboarding_1: BaseImage { .init() }
    static var onboarding_2: BaseImage { .init() }
    static var onboarding_3: BaseImage { .init() }
    static var onboarding_4: BaseImage { .init() }
    static var authorizationMethodType: BaseImage { .init() }
    static var bell: BaseImage { .init() }
    static var binoculars: BaseImage { .init() }
    static var calendar: BaseImage { .init() }
    static var camera: BaseImage { .init() }
    static var lock: BaseImage { .init() }
    static var ellipse: BaseImage { .init() }
    static var ellipseChecked: BaseImage { .init() }
    static var checkOn: BaseImage { .init() }
    static var checkOff: BaseImage { .init() }
    static var faceId: BaseImage { .init() }
    static var fingerprintScan: BaseImage { .init() }
    static var backspace: BaseImage { .init() }
    static var loaderDone: BaseImage { .init() }
    static var yourFreedomCardIsReady: BaseImage { .init() }
    static var chevronRight: BaseImage { .init() }
    static var chevronBottom: BaseImage { .init() }
    static var roundClose: BaseImage { .init() }
    static var applePay: BaseImage { .init() }
    static var lockClosed: BaseImage { .init() }
//    static var visa: BaseImage { .init() }
//    static var mastercard: BaseImage { .init() }
    static var plusGreen: BaseImage { .init() }
    static var deleteRow: BaseImage { .init() }
    
    static var home: BaseImage { .init() }
    static var pt: BaseImage { .init() }
    static var service: BaseImage { .init() }
    static var chat: BaseImage { .init() }
    static var more: BaseImage { .init() }

    static var home_story_1: BaseImage { .init() }
    static var home_story_2: BaseImage { .init() }
    static var home_story_3: BaseImage { .init() }
    static var home_story_4: BaseImage { .init() }
    static var openCard: BaseImage { .init() }
    static var openDeposit: BaseImage { .init() }
    static var getCredit: BaseImage { .init() }
    
    static var deposit: BaseImage { .init() }
    static var kzt: BaseImage { .init() }
    static var usd: BaseImage { .init() }
    static var eur: BaseImage { .init() }
    static var rub: BaseImage { .init() }
    static var mortgage: BaseImage { .init() }
    static var carLoan: BaseImage { .init() }
    static var cardMiniatureVisa: BaseImage { .init() }
    static var cardMiniatureMaster: BaseImage { .init() }

    static var profile_bonuses: BaseImage { .init() }
    static var profile_clock: BaseImage { .init() }
    static var profile_email: BaseImage { .init() }
    static var profile_faceID: BaseImage { .init() }
    static var profile_language: BaseImage { .init() }
    static var profile_location: BaseImage { .init() }
    static var profile_notification: BaseImage { .init() }
    static var profile_passcode: BaseImage { .init() }
    static var profile_payment: BaseImage { .init() }
    static var profile_phone: BaseImage { .init() }
    static var profile_decoration: BaseImage { .init() }
    static var selection: BaseImage { .init() }
    static var digitalDocuments: BaseImage { .init() }
    static var warningBase: BaseImage { .init() }
    static var stroke: BaseImage { .init() }
    static var bonus: BaseImage { .init() }
    static var scaner: BaseImage { .init() }
    static var share: BaseImage { .init() }
    static var freedomStocks: BaseImage { .init() }
    static var freedomCard: BaseImage { .init() }
    static var freepayCard: BaseImage { .init() }
    static var investCard: BaseImage { .init() }
    static var themeWhite: BaseImage { .init() }
    static var themeBlack: BaseImage { .init() }
    static var themeSystem: BaseImage { .init() }
    static var limits_info: BaseImage { .init() }
    static var limits_cloud: BaseImage { .init() }

    static var pdBlockedCard: BaseImage { .init() }
    static var pdReferences: BaseImage { .init() }
    static var pdFavorites: BaseImage { .init() }
    static var pdConditions: BaseImage { .init() }
    static var pdLimits: BaseImage { .init() }
    static var pdChangePin: BaseImage { .init() }
    static var pdPlastic: BaseImage { .init() }
    static var pdCloseCard: BaseImage { .init() }
    static var pdLock: BaseImage { .init() }
    static var pdInternetPayments: BaseImage { .init() }
    static var changeTheme: BaseImage { .init() }
    static var mastercardTitle: BaseImage { .init() }
    static var visaTitle: BaseImage { .init() }
    
    static var transactionTransfer: BaseImage { .init() }
    static var transactionAparking: BaseImage { .init() }
    static var transactionMagnum: BaseImage { .init() }
    static var replenishmentAction: BaseImage { .init() }
    static var transferAction: BaseImage { .init() }
    static var paymentAction: BaseImage { .init() }
    static var conversionAction: BaseImage { .init() }
    static var expand: BaseImage { .init() }
    static var freedomBankColorless: BaseImage { .init() }
    static var mastercardColorless: BaseImage { .init() }
    static var copy: BaseImage { .init() }
    static var mark: BaseImage { .init() }
    static var pdTransfer: BaseImage { .init() }
    static var pdReplenishment: BaseImage { .init() }
    static var topUp: BaseImage { .init() }
    static var withdrawСash: BaseImage { .init() }
    static var productEdit: BaseImage { .init() }
    static var selected: BaseImage { .init() }
    static var contacts: BaseImage { .init() }
    static var tpRecentRequests: BaseImage { .init() }
    static var tele2operator: BaseImage { .init() }
    static var onayTransport: BaseImage { .init() }
    static var dots: BaseImage { .init() }
    static var favoritesEmpty: BaseImage { .init() }
    
    // mock
    static var smallBanner40: BaseImage { .init() }
    static var card44: BaseImage { .init() }
    static var iconBlue: BaseImage { .init() }
    static var iconRed: BaseImage { .init() }
    static var iconDefault: BaseImage { .init() }
    static var openNewInvestPlaceholder: BaseImage { .init() }

    //BG
    static var pdReward: BaseImage { .init() }

    //JC
    static var JC: BaseImage { .init() }
    static var JCFeature: BaseImage { .init() }
    static var JCSuccess: BaseImage { .init() }
    static var openInvest: BaseImage { .init() }
    static var openInvestCard2: BaseImage { .init() }
    static var openInvestCard3: BaseImage { .init() }
    static var appleIcon: BaseImage { .init() }
}
