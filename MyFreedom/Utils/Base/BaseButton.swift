//
//  BaseButton.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit

class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setEnabled(true)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setEnabled(_ isEnabled: Bool, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: Constants.AnimationDurationList.commonButtonChangeState, animations: {
                self.alpha = isEnabled ? 1.0 : 0.5
            })
        } else {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
