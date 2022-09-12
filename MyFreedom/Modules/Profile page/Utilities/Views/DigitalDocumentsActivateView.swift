//
//  ActivateDigitalDocumentsView.swift
//  MyFreedom
//
//  Created by &&TairoV on 17.05.2022.
//

import UIKit

protocol ActivateDigitalDocument {
    func tapActivate()
}

class DigitalDocumentsActivateView: UIView {
    
    var delegate: ActivateDigitalDocument?
    private let titleLabel: UILabel = build() {
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.semibold.withSize(16)
        $0.text = "Цифровые документы"
    }
    
    private let subtitleLabel: UILabel = build() {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.medium.withSize(14)
        $0.text = "Добавьте, чтобы всегда были под рукой"
    }
    
    private let spaceView = UIView()
    
    private let activateButton: UIButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Добавить документы", for: .normal)
        $0.setImage(BaseImage.document.uiImage, for: .normal)
        $0.layer.cornerRadius = 16
    }
    
    private lazy var contentStackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, spaceView, activateButton])) {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 12
        configureSubviews()
        
        activateButton.addTarget(self, action: #selector(activateDocument), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        addSubview(contentStackView)
        
        var layoutContraints = [NSLayoutConstraint]()
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints += contentStackView.getLayoutConstraints(over: self, safe: true, left: 16, top: 16, right: 16, bottom: 16)
        
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints += [spaceView.heightAnchor.constraint(equalToConstant: 8)]
        
        activateButton.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints += [activateButton.heightAnchor.constraint(equalToConstant: 52)]
        
        NSLayoutConstraint.activate(layoutContraints)
    }
    
    @objc func activateDocument() {
        delegate?.tapActivate()
    }
}

extension DigitalDocumentsActivateView: CleanableView {
    var contentInset: UIEdgeInsets { .init(top: 0, left: 16, bottom: 0, right: 16) }
    
    func clean() { }
}
