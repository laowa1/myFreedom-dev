//
//  KeyboardStateObserver.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

class KeyboardStateObserver: KeyboardStateObserverType {
    public var keyboardStateHandler: KeyboardStateEventClosure?
    public var keyboardStateHandlerExtended: KeyboardStateEventClosure?
    
    private var keyboadObservers: [Any]? = nil
    
    public init() {}
        
    public func startListening() {
        let showObserver = addObserver(name: UIResponder.keyboardWillShowNotification)
        let hideObserver = addObserver(name: UIResponder.keyboardWillHideNotification)
        keyboadObservers = ([showObserver, hideObserver])
    }
    public func stopListening() {
        _ = keyboadObservers?.map{ NotificationCenter.default.removeObserver($0) }
    }
    deinit {
        _ = keyboadObservers?.map{ NotificationCenter.default.removeObserver($0) }
    }
}

//MARK: - Helper methods
private extension KeyboardStateObserver {
    private func addObserver(name: NSNotification.Name) -> NSObjectProtocol {
        let observer = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { notification in
            if let state = self.fetchState(name: name, handleDidStates: false),
               let params = self.setupHandler(notification: notification, state: state) {
                self.keyboardStateHandler?(params)
            }
            if let stateExtended = self.fetchState(name: name, handleDidStates: true),
               let params = self.setupHandler(notification: notification, state: stateExtended) {
                self.keyboardStateHandlerExtended?(params)
            }
        }
        return observer
    }
    
    private func setupHandler(notification: Notification, state: KeyboardState) -> KeyboardParams? {
        guard let info = notification.userInfo,
              let rect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let time = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return nil }
        return KeyboardParams(rect: rect, animationTime: time, animationCurve: curve, state: state)
    }
    
    private func fetchState(name: NSNotification.Name, handleDidStates: Bool = false) -> KeyboardState? {
        switch name {
        case UIResponder.keyboardWillShowNotification:
            return .willShow
        case UIResponder.keyboardWillHideNotification:
            return .willHide
        case UIResponder.keyboardDidShowNotification:
            return handleDidStates ? .willShow : nil
        case UIResponder.keyboardDidHideNotification:
            return handleDidStates ? .willHide : nil
        default:
            return nil
        }
    }
}
