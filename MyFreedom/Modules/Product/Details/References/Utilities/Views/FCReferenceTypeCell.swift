//
//  FCReferenceView.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.06.2022.
//

import UIKit

class FCReferenceTypeCell: UITableViewCell {

    private let titleLabel: UILabel =  build {
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.semibold.withSize(18)
    }

    private let subtitleLabel: UILabel = build {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.medium.withSize(13)
    }

    private lazy var labelStack: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])) {
        $0.axis = .vertical
        $0.spacing = 2
    }

    private let iconImage: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    private let accessoryImage: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var mainView: UIView = build {
        $0.layer.borderColor = BaseColor.green500.cgColor
        $0.backgroundColor = BaseColor.base50
        $0.layer.cornerRadius = 12
    }

    private lazy var mainStack: UIStackView = build(UIStackView(arrangedSubviews: [iconImage, labelStack, accessoryImage])) {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 12
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.23) { [weak self] in
            guard let view = self else { return }
            view.setSelected(selected: selected)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mainView.layer.borderWidth = 0
    }

    private func configureSubviews() {
        selectionStyle = .none
        addSubview(mainView)
        mainView.addSubview(mainStack)

        backgroundColor = .clear
        accessoryImage.image = BaseImage.mark.uiImage
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += mainView.getLayoutConstraints(over: self, left: 16, top: 6, right: 16, bottom: 6)

        mainStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += mainStack.getLayoutConstraints(over: mainView, margin: 16)

        iconImage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconImage.heightAnchor.constraint(equalToConstant: 32),
            iconImage.widthAnchor.constraint(equalToConstant: 32)
        ]

        accessoryImage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            accessoryImage.heightAnchor.constraint(equalToConstant: 24),
            accessoryImage.widthAnchor.constraint(equalToConstant: 24)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func setSelected(selected: Bool) {
        accessoryImage.isHidden = !selected
        titleLabel.textColor = selected ? BaseColor.green500 : BaseColor.base900
        mainView.layer.borderWidth = selected ? 1.5 : 0
    }

    func configure(viewModel: FCReferenceFieldItemElement) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImage.image = viewModel.image
    }
}
