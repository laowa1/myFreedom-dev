//
//  DigitalDocumentsUnavailableView.swift
//  MyFreedom
//
//  Created by &&TairoV on 17.05.2022.
//

import UIKit

class DigitalDocumentsUnavailableView: UIView {
    
    private var warningImage = UIImageView()
    private lazy var warningView = UIView()
    private var headerTitle: UILabel = build {
        $0.textColor = BaseColor.base500
        $0.font = BaseFont.medium.withSize(13)
        $0.text = "Цифровые документы"
    }
    
    private let titleLabel: UILabel =  build {
        $0.textColor = BaseColor.base800
        $0.font = BaseFont.semibold.withSize(14)
        $0.text = "Сервис госуслуг временно недоступен"
    }
    
    private let subtitleLabel: UILabel = build {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.medium.withSize(13)
        $0.text = "Попробуйте позже"
    }
    
    private lazy var warningLabelStack: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])) {
        $0.axis = .vertical
    }
    
    private lazy var mainStack: UIStackView = build(UIStackView(arrangedSubviews: [headerTitle, warningView])) {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
        setupLayout()
        stylize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        addSubview(mainStack)
        warningView.addSubview(warningImage)
        warningView.addSubview(warningLabelStack)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += mainStack.getLayoutConstraints(over: self)
        
        warningImage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            warningImage.heightAnchor.constraint(equalToConstant: 32),
            warningImage.widthAnchor.constraint(equalToConstant: 32),
            warningImage.topAnchor.constraint(equalTo: warningView.topAnchor, constant: 18),
            warningImage.leadingAnchor.constraint(equalTo: warningView.leadingAnchor, constant: 12),
            warningImage.bottomAnchor.constraint(equalTo: warningView.bottomAnchor, constant: -18),
            warningImage.trailingAnchor.constraint(equalTo: warningLabelStack.leadingAnchor, constant: -8)
        ]
        
        warningLabelStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            warningLabelStack.topAnchor.constraint(equalTo: warningView.topAnchor, constant: 18),
            warningLabelStack.trailingAnchor.constraint(equalTo: warningView.trailingAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func stylize() {
        warningView.backgroundColor = .white
        warningView.layer.cornerRadius = 12
        
        warningImage.image = BaseImage.warningBase.uiImage
    }
}

extension DigitalDocumentsUnavailableView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 16, bottom: 0, right: 16) }
    
    func clean() {}
}
