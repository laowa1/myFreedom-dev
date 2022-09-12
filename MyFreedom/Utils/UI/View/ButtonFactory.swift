//
//  ButtonFactory.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit

protocol CustomButtonFactoryProtocol {
    func getGreenButton(cornerRadius: CGFloat) -> BaseButton
    func getWhiteButton() -> BaseButton
    func getTextButton() -> BaseButton
    func getForgotTextButton() -> BaseButton
    func getNotAcceptButton() -> BaseButton
}

class ButtonFactory: CustomButtonFactoryProtocol {

    func getGreenButton(cornerRadius: CGFloat = 16.0) -> BaseButton {
        return setupButton(BaseColor.green500, BaseColor.base50, cornerRadius: cornerRadius)
    }

    func getWhiteButton() -> BaseButton {
        return setupButton(.clear, BaseColor.green500)
    }

    func getTextButton() -> BaseButton {
        return setupButton(BaseColor.green500, BaseColor.base50, true)
    }

    func getForgotTextButton() -> BaseButton {
        return setupButton(BaseColor.green500, BaseColor.base50, true)
    }

    func getNotAcceptButton() -> BaseButton {
        return setupButton(BaseColor.base200, BaseColor.base800)
    }

    private func setupButton(_ backgroundColor: UIColor,
                             _ textColor: UIColor = .white,
                             _ isTextButton: Bool = false,
                             cornerRadius: CGFloat = 16.0) -> BaseButton
    {
        let button = BaseButton(type: .custom)
        if !isTextButton {
            button.titleLabel?.font = BaseFont.medium.withSize(17)
            button.setTitleColor(textColor, for: .normal)
            button.backgroundColor = backgroundColor
            button.layer.cornerRadius = cornerRadius
            button.clipsToBounds = true
        } else {
            button.setTitleColor(backgroundColor, for: .normal)
            button.backgroundColor = .none
            button.titleLabel?.font = BaseFont.regular.withSize(14)
        }
        return button
    }
}

