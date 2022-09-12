//
//  BaseFont.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit.UIFont

class BaseFont: RawRepresentable, Equatable {
    
    typealias RawValue = String
    
    let rawValue: RawValue
    
    let withExtension: String
    
    required init?(rawValue: String) { fatalError("Not implemented") }

    required public init(title: String, withExtension: String) {
        self.rawValue = title
        self.withExtension = withExtension
    }
}

extension BaseFont: CommonFontProtocol {
    
    var title: String { rawValue }
    
    var bundle: Bundle { Bundle(for: BaseFont.self) }
    
    private var uiFont: UIFont? {
        if let font = UIFont(name: title, size: 16) {
            return font
        }
        
        guard let url = bundle.url(forResource: title, withExtension: withExtension),
              let cgDataProvider = CGDataProvider(url: url as CFURL),
              let cgFont = CGFont(cgDataProvider),
              CTFontManagerRegisterGraphicsFont(cgFont, nil) else {
            return nil
        }
        
        return UIFont(name: title, size: 16)
    }
    
    private static var SFProDisplayLight: BaseFont { .init(title: "SF-Pro-Display-Light", withExtension: "otf") }
    private static var SFProDisplayRegular: BaseFont { .init(title: "SF-Pro-Display-Regular", withExtension: "otf") }
    private static var SFProDisplaySemibold: BaseFont { .init(title: "SF-Pro-Display-Semibold", withExtension: "otf") }
    private static var SFProDisplayMedium: BaseFont { .init(title: "SF-Pro-Display-Medium", withExtension: "otf") }
    private static var SFProDisplayBold: BaseFont { .init(title: "SF-Pro-Display-Bold", withExtension: "otf") }

    static var light: UIFont { SFProDisplayLight.uiFont ?? .systemFont(ofSize: 16, weight: .light) }
    static var regular: UIFont { SFProDisplayRegular.uiFont ?? .systemFont(ofSize: 16, weight: .regular) }
    static var semibold: UIFont { SFProDisplaySemibold.uiFont ?? .systemFont(ofSize: 16, weight: .semibold) }
    static var medium: UIFont { SFProDisplayMedium.uiFont ?? .systemFont(ofSize: 16, weight: .medium) }
    static var bold: UIFont { SFProDisplayBold.uiFont ?? .systemFont(ofSize: 16, weight: .bold) }
    
}

protocol CommonFontProtocol {
    
    var bundle: Bundle { get }

    var title: String { get }

    var withExtension: String { get }
}
