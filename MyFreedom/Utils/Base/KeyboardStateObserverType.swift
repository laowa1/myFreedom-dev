//
//  KeyboardStateObserverType.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

protocol KeyboardStateObserverType: AnyObject {
    func startListening()
    func stopListening()
    var keyboardStateHandler: KeyboardStateEventClosure? { get set }
    var keyboardStateHandlerExtended: KeyboardStateEventClosure? { get set }
}

protocol KeyboardStateObserverFactoryType: AnyObject {
    func produce() -> KeyboardStateObserverType
}

class KeyboardStateObserverFactory: KeyboardStateObserverFactoryType {
    init() {}
    
    func produce() -> KeyboardStateObserverType {
        return KeyboardStateObserver()
    }
}

typealias KeyboardStateEventClosure = (KeyboardParams) -> Void

enum KeyboardState {
    case willShow, willHide
}

struct KeyboardParams {
    let rect: CGRect
    let animationTime: TimeInterval
    let animationCurve: UInt
    let state: KeyboardState
}
