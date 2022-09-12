//
//  HintStackView.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 15.03.2022.
//

import UIKit

struct HintSVModel {
    var icon: BaseImage? = nil
    let text: String
    var isError: Bool = false
}

final class HintStackView: UIStackView {
    
    private let iconView = UIImageView()
    private let label: UILabel = build {
        $0.numberOfLines = 0
        $0.font = BaseFont.regular.withSize(13)
        $0.textAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 16.0
        alignment = .center
        distribution = .fill
    
        iconView.contentMode = .scaleAspectFit
        iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        addArrangedSubviews([iconView, label])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with model: HintSVModel) {
        let color = model.isError ? BaseColor.red700 : BaseColor.base500
        iconView.image = model.icon?.uiImage?.withTintColor(color)
        
        label.textColor = color
        label.text = model.text
    }
}
