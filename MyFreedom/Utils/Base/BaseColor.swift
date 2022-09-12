//
//  BaseColor.swift
//  MyFreedom
//
//  Created by Sanzhar on 11.03.2022.
//

import UIKit.UIColor

enum BaseColor: String, CaseIterable {
        
    case _DBF1E3, _B8E4C7, _4EBC73, _2E8452, _11583C                                        // Green
    case _FFFFFF, _F7F7F7, _EAECED, _D1D1D6, _AEAEB2, _8E8E93, _636366, _3A3A3C, _000000,   // Base
         _1A1A1A, _2B2B2E, _C7C7CC, _F2F2F7
    case _CCEEFF, _66BDFF, _007AFF, _005EDB, _003193                                        // Blue
    case _DFDEFC, _9D9BF2, _5856D6, _403EB8, _2C2B9A                                        // Indigo
    case _FFE1D6, _FF8E84, _FF3347, _DB2547, _B71946                                        // Red
    case _FFDCD5, _FF8181, _FF2D55, _DB2056, _930E4D                                        // Pink
    case _FFF9CC, _FFE666, _FFCC00, _DBAA00                                                 // Yellow
    case _FFF2CC, _FFCC66, _FF9500, _DB7600                                                 // Orange
    case _36A75D, _3E847E, _00B78D
    case _4CD964, _3A3939, _686868, _2F48CD, _82488B, _C23378, _454543, _2D2D46, _65649A

    
    public var uiColor: UIColor { UIColor(hex: hex) ?? .black }
    public var cgColor: CGColor { uiColor.cgColor }
    public var hex: String { rawValue.replacingOccurrences(of: "_", with: "#") }
    private static var currentTheme: Theme {
        if let rawValue: String = KeyValueStore().getValue(for: .theme),
            let theme = Theme(rawValue: rawValue) {
            return theme
        }
        return .light
    }
}

extension BaseColor {
    
    // Green
    static var green100: UIColor { _DBF1E3.uiColor }
    static var green300: UIColor { _B8E4C7.uiColor }
    static var green500: UIColor { _4EBC73.uiColor }
    static var green700: UIColor { _2E8452.uiColor }
    static var green900: UIColor { _11583C.uiColor }
    
    // Base
    static var base50: UIColor { currentTheme == .light ? _FFFFFF.uiColor : _1A1A1A.uiColor }
    static var base100: UIColor { currentTheme == .light ? _F7F7F7.uiColor : _000000.uiColor }
    static var base200: UIColor { currentTheme == .light ? _EAECED.uiColor : _2B2B2E.uiColor }
    static var base300: UIColor { currentTheme == .light ? _D1D1D6.uiColor : _3A3A3C.uiColor }
    static var base400: UIColor { currentTheme == .light ? _AEAEB2.uiColor : _636366.uiColor }
    static var base500: UIColor { currentTheme == .light ? _8E8E93.uiColor : _C7C7CC.uiColor }
    static var base700: UIColor { currentTheme == .light ? _636366.uiColor : _D1D1D6.uiColor }
    static var base800: UIColor { currentTheme == .light ? _3A3A3C.uiColor : _F2F2F7.uiColor }
    static var base900: UIColor { currentTheme == .light ? _000000.uiColor : _FFFFFF.uiColor }
    
    // Blue
    static var blue100: UIColor { _CCEEFF.uiColor }
    static var blue300: UIColor { _66BDFF.uiColor }
    static var blue500: UIColor { _007AFF.uiColor }
    static var blue700: UIColor { _005EDB.uiColor }
    static var blue900: UIColor { _003193.uiColor }
    
    // Indigo
    static var indigo100: UIColor { _DFDEFC.uiColor }
    static var indigo300: UIColor { _9D9BF2.uiColor }
    static var indigo500: UIColor { _5856D6.uiColor }
    static var indigo700: UIColor { _403EB8.uiColor }
    static var indigo900: UIColor { _2C2B9A.uiColor }
    
    // Red
    static var red100: UIColor { _FFE1D6.uiColor }
    static var red300: UIColor { _FF8E84.uiColor }
    static var red500: UIColor { _FF3347.uiColor }
    static var red700: UIColor { _DB2547.uiColor }
    static var red900: UIColor { _B71946.uiColor }
    
    // Pink
    static var pink100: UIColor { _FFDCD5.uiColor }
    static var pink300: UIColor { _FF8181.uiColor }
    static var pink500: UIColor { _FF2D55.uiColor }
    static var pink700: UIColor { _DB2056.uiColor }
    static var pink900: UIColor { _930E4D.uiColor }
    
    // Yellow
    static var yellow100: UIColor { _FFF9CC.uiColor }
    static var yellow300: UIColor { _FFE666.uiColor }
    static var yellow500: UIColor { _FFCC00.uiColor }
    static var yellow700: UIColor { _DBAA00.uiColor }
    
    // Orange
    static var orange100: UIColor { _FFF2CC.uiColor }
    static var orange300: UIColor { _FFCC66.uiColor }
    static var orange500: UIColor { _FF9500.uiColor }
    static var orange700: UIColor { _DB7600.uiColor }
}
