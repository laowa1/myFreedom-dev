//
//  CustomSubtitle.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

class CustomSubtitle: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    init() {
        super.init(frame: .zero)
        setupSubtitleLabel ()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubtitleLabel() {
        let size: CGFloat = UIDevice.current.isSmallScreen ? 24 : 28
        font = BaseFont.bold.withSize(size)
        textColor = BaseColor.base900
        textAlignment = .left
        numberOfLines = 0
    }
}
