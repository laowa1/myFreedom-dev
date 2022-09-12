//
//  RefreshControl.swift
//  MyFreedom
//
//  Created by m1 on 30.06.2022.
//

import UIKit

class RefreshControl: UIRefreshControl {

    override public init() {
        super.init(frame: .zero)

        tintColor = BaseColor.base200
    }

    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

