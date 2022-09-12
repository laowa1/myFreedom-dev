//
//  AgreementStackView.swift
//  MyFreedom
//
//  Created by &&TairoV on 04.04.2022.
//

import UIKit

protocol AgreementSVDelegate {
    func didChangeRadio(isSelected: Bool)
    func didSelectLabel()
}

struct AgreementSVModel {
    var iconOff: BaseImage = BaseImage.checkOff
    var iconOn: BaseImage = BaseImage.checkOn
    let text: NSAttributedString
    let isSelected: Bool
    var delegate: AgreementSVDelegate?
}

final class AgreementStackView: UIStackView {

    var delegate: AgreementSVDelegate?
    var id: UUID?

    private lazy var acceptButton: UIButton = build {
        $0.addTarget(self, action: #selector(acceptTerms), for: .touchUpInside)
    }

    private lazy var label: UILabel = build {
        $0.isUserInteractionEnabled = true
        $0.numberOfLines = 0
        $0.font = BaseFont.regular.withSize(14)
        $0.textAlignment = .left
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDocumentList)))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 16.0
        alignment = .top
        distribution = .fill

        acceptButton.contentMode = .scaleAspectFit
        acceptButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: 24).isActive = true

        addArrangedSubviews([acceptButton, label])
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(with model: AgreementSVModel) {
        delegate = model.delegate

        acceptButton.isSelected = model.isSelected
        acceptButton.setImage(model.iconOff.uiImage, for: .normal)
        acceptButton.setImage(model.iconOn.uiImage, for: .selected)

        label.textColor = BaseColor.base500
        label.attributedText = model.text
    }

    @objc private func acceptTerms(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.didChangeRadio(isSelected: sender.isSelected)
    }

    @objc private func showDocumentList() {
        delegate?.didSelectLabel()
    }
}
