//
//  PDLimitsItemView.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import UIKit

class PDLimitsItemView: UIView {

    private lazy var topView: UIView = build {
        $0.addSubviews(titleButton, toogleButton)
    }

    let titleButton: UIButton = build(ButtonFactory().getTextButton()) {
        $0.setTitleColor(BaseColor.base700, for: .normal)
        $0.setImage(BaseImage.limits_info.uiImage, for: .normal)
        $0.imageEdgeInsets.left = 4
        $0.semanticContentAttribute = .forceRightToLeft
    }
    
    let toogleButton: UIButton = build(ButtonFactory().getTextButton()) {
        $0.setTitle("Изменить", for: .normal)
    }
    
    private lazy var bottomView: UIStackView = build {
        $0.distribution = .fill
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 8
        $0.addArrangedSubviews(bottomTitle, progressView, bottomLabelsView)
    }
    
    private var bottomTitle: UILabel = build {
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.semibold.withSize(16)
    }
    
    private var progressView = ProgressView()
    
    private var bottomLabelsView = PDLimitsBottomView()

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [topView, bottomView])) {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 16
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        confgiureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func confgiureSubviews() {
        layer.cornerRadius = 12
        backgroundColor = BaseColor.base50
        addSubview(stackView)
        setupLayout()
    }

    private func setupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self, safe: false, margin: 16)

        titleButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleButton.topAnchor.constraint(equalTo: topView.topAnchor),
            titleButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            titleButton.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            titleButton.heightAnchor.constraint(equalToConstant: 22)
        ]
        
        toogleButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            toogleButton.topAnchor.constraint(equalTo: titleButton.topAnchor),
            toogleButton.bottomAnchor.constraint(equalTo: titleButton.bottomAnchor),
            toogleButton.rightAnchor.constraint(equalTo: topView.rightAnchor),
            toogleButton.heightAnchor.constraint(equalToConstant: 22),
        ]
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            progressView.heightAnchor.constraint(equalToConstant: 6)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(viewModel: PDLimitsElement) {
        viewModel.amount?.amount.visableAmount.map { bottomTitle.text = "\($0) в месяц" }
        titleButton.setTitle(viewModel.title, for: .normal)
        progressView.change(to: CGFloat(Int.random(in: 0..<100)))
        
        bottomLabelsView.configure(viewModel: PDLimitsBottomItem())
    }
}

extension PDLimitsItemView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 8, left: 16, bottom: 8, right: 16) }
    
    var containerBackgroundColor: UIColor { BaseColor.base100 }
    
    func clean() {
        bottomTitle.text = nil
        titleButton.setTitle(nil, for: .normal)
    }
}
