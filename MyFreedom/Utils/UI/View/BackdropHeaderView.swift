//
//  BackdropHeaderView.swift
//  MobileBanking-KassanovaBank
//
//  Created by bnazhdev on 29.09.2021.
//

import UIKit

class BackdropHeaderView: UIView {
    
    private lazy var heightConstraint = closeButton.heightAnchor.constraint(equalToConstant: 24)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = BaseFont.medium.withSize(16)
        label.textAlignment = .left
        label.textColor = BaseColor.base900
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = BaseColor.base200
        button.setImage(BaseImage.roundClose.uiImage, for: .normal)
        button.setTitleColor(BaseColor.base800, for: .normal)
        button.titleLabel?.font = BaseFont.medium.withSize(13)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private var handleClose: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }


    private func configureSubviews() {
        backgroundColor = .clear
        addSubview(closeButton)
        addSubview(titleLabel)
        
        var layoutConstraints = [NSLayoutConstraint]()

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            heightConstraint,
            closeButton.widthAnchor.constraint(equalToConstant: 24)
        ]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    @objc private func closeAction() {
        handleClose?()
    }

    func configure(title: String, buttonTitle: String? = nil, hideButton: Bool = false, handleClose: (() -> Void)? = nil) {
        titleLabel.text = title
        
        closeButton.isHidden = hideButton
        if let title = buttonTitle {
            closeButton.setImage(nil, for: .normal)
            closeButton.setTitle(title, for: .normal)
            closeButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
            heightConstraint.constant = 30
        }

        self.handleClose = handleClose
    }
}

extension BackdropHeaderView: CleanableView {

    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) }

    func clean() {
        closeButton.setImage(nil, for: .normal)
        closeButton.setTitle(nil, for: .normal)
        titleLabel.text = nil
    }
}
