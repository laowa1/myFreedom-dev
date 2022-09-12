//
//  PDLimitsBottomView.swift
//  MyFreedom
//
//  Created by m1pro on 13.06.2022.
//

import Foundation
import UIKit.UIView

struct PDLimitsBottomItem: BottomSheetPickerItemProtocol {
    let title: String = "0 ₸"
    var description: String? = "500 000 ₸"
    var bottomTitle: String = "Израсходовано"
    var bottomDescription: String = "Осталось"
}

class PDLimitsBottomView: UIView {
    
    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [topStackView, bottomStackView])) {
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    private lazy var topStackView: UIStackView = build {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addArrangedSubviews(titleLabel, descriptionLabel)
    }
    private let titleLabel: UILabel = build {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = BaseFont.medium.withSize(13)
        $0.textColor = BaseColor.base900
    }
    private var descriptionLabel: UILabel = build {
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.font = BaseFont.medium.withSize(13)
        $0.textColor = BaseColor.base900
    }
    private lazy var bottomStackView: UIStackView = build {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addArrangedSubviews(bottomTitleLabel, bottomDescriptionLabel)
    }
    private let bottomTitleLabel: UILabel = build {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = BaseFont.regular.withSize(11)
        $0.textColor = BaseColor.base500
    }
    private var bottomDescriptionLabel: UILabel = build {
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.font = BaseFont.regular.withSize(11)
        $0.textColor = BaseColor.base500
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        confgiureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func confgiureSubviews() {
        addSubview(stackView)
        backgroundColor = .clear
        stupLayout()
    }

    private func stupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(viewModel: PDLimitsBottomItem) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        bottomTitleLabel.text = viewModel.bottomTitle
        bottomDescriptionLabel.text = viewModel.bottomDescription
    }
}
