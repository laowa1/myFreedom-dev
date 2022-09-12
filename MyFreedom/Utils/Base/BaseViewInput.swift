//
//  BaseViewInput.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

protocol BaseViewInput where Self: UIViewController { }

extension BaseViewInput {
    
    @discardableResult
    func showAlert(title: String?,
                   message: String?,
                   style: UIAlertController.Style = .alert,
                   actions: [UIAlertAction] = []) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        actions.forEach {
            alert.addAction($0)
        }
        
        present(alert, animated: true, completion: nil)
        
        return alert
    }

    @discardableResult
    func showAlertWithOkAction(title: String?,
                               message: String?,
                               style: UIAlertController.Style = .alert,
                               okActionHandler: (() -> Void)? = nil,
                               otherActions: [UIAlertAction] = []) -> UIAlertController {
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            okActionHandler?()
        }
        
        return showAlert(title: title, message: message, style: style, actions: [okAction] + otherActions)
    }

    func showAlert(
        title: String?,
        message: String?,
        style: UIAlertController.Style = .alert,
        first: UIAlertAction,
        second: UIAlertAction? = nil,
        secondColor: UIColor = BaseColor.green500
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if let second = second {
            second.setValue(secondColor, forKey: "titleTextColor")
            alert.addAction(second)
            
            first.setValue(BaseColor.base700, forKey: "titleTextColor")
        }
    
        alert.addAction(first)
        
        present(alert, animated: true, completion: nil)
    }
    
    func show(warning: String) {
        showAlertWithOkAction(title: warning, message: nil)
    }
    
}

extension UIAlertAction {

    convenience init(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?, textColor: UIColor) {
        self.init(title: title, style: style, handler: handler)
        setValue(textColor, forKey: "titleTextColor")
    }
}
