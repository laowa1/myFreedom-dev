//
//  ButtonClickActions.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//

import UIKit

final class ActionTap: NSObject {
    
    private var buttonTap: (_ sender: UITapGestureRecognizer) -> ()
    
    init(block: @escaping (_ sender: UITapGestureRecognizer) -> ()) {
        buttonTap = block
        super.init()
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        buttonTap(sender)
    }
}

final class ActionClick: NSObject {
    
    private var clickButton: (_ sender: UIButton) -> ()
    
    init(block: @escaping (_ sender: UIButton) -> ()) {
        clickButton = block
        super.init()
    }
    
    @objc func click(sender: UIButton) {
        clickButton(sender)
    }
}

protocol Actionable: AnyObject { }

extension UIView: Actionable {
    
    fileprivate struct CustomProperties {
        static var tapAction: ActionTap?
        static var clickAction: ActionClick?
    }
    
    fileprivate func getAssociatedObject<T>(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            return defaultValue
        }
        return value
    }
}

extension UIView {
    
    var parentViewController: UIViewController? {
        
        var responder: UIResponder? = self
        while let next = responder?.next {
            guard let vc = next as? UIViewController else { responder = next; continue }
            return vc
        }
        return nil
    }
}

extension Actionable where Self: UIView {
    
    var actionTap: ActionTap? {
        get {
            return getAssociatedObject(&CustomProperties.tapAction, defaultValue: CustomProperties.tapAction)
        }
        set {
            objc_setAssociatedObject(self, &CustomProperties.tapAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let tap = UITapGestureRecognizer.init(target: self.actionTap, action: #selector(self.actionTap?.tap(sender:)))
            self.addGestureRecognizer(tap)
            self.isUserInteractionEnabled = true
        }
    }
    
    func tap(_ selector: Selector) {
        guard let target = self.parentViewController else {return}
        if self.gestureRecognizers?.first(where: {$0 is UITapGestureRecognizer}) == nil {
            let tap = UITapGestureRecognizer(target: target, action: selector)
            self.addGestureRecognizer(tap)
            self.isUserInteractionEnabled = true
        }
    }
}

extension Actionable where Self: UIButton {
    
    var actionClick: ActionClick? {
        get {
            return getAssociatedObject(&CustomProperties.clickAction, defaultValue: CustomProperties.clickAction)
        }
        set {
            objc_setAssociatedObject(self, &CustomProperties.clickAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.addTarget(self.actionClick, action: #selector(self.actionClick?.click(sender:)), for: .touchUpInside)
        }
    }
    
    func click(_ selector: Selector) {
        guard let target = self.parentViewController else {return}
        if self.actions(forTarget: target, forControlEvent: .touchUpInside) == nil {
            self.addTarget(target, action: selector, for: .touchUpInside)
        }
    }
}
