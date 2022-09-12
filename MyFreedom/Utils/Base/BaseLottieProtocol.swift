//
//  BaseLottieProtocol.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 26.04.2022.
//

import Lottie
import Foundation

protocol BaseLottieProtocol {
    
    var rawValue: String { get }
    
    var bundle: Bundle { get }
}

extension BaseLottieProtocol {
    
    var animation: Animation? { Animation.named(rawValue, bundle: bundle) }
}

class BaseLottie: RawRepresentable, Equatable {
    
    typealias RawValue = String
    
    let rawValue: RawValue
    
    let bundle: Bundle
    
    required init?(rawValue: String) { fatalError("Not implemented") }
    
    required init(rawValue: String = #function, from bundle: Bundle = .init(for: BaseLottie.self)) {
        self.rawValue = rawValue
        self.bundle = bundle
    }
}

extension BaseLottie: BaseLottieProtocol {
    
    static var toastWarning: BaseLottie { .init() }
    static var copied: BaseLottie { .init() }
}
