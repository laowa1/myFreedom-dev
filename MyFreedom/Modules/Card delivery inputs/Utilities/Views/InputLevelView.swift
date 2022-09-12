//
//  InputLevelView.swift
//  MyFreedom
//
//  Created by Sanzhar on 28.06.2022.
//

import UIKit

class InputLevelView: UIView {
    
    private weak var delegate: InputLevelDelegate?
    
    private let currentLevelLabel = UILabel()
    private let backgroundLevelLine = UIView()
    private let currentLevelLine = UIView()
    private let currentLevelView = UIView()
    private lazy var backButton: BaseButton = build(ButtonFactory().getTextButton()) {
        $0.layer.borderColor = BaseColor.green500.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.setImage(BaseImage.expand.uiImage(tintColor: BaseColor.green500), for: .normal)
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    private lazy var nextButton: BaseButton = build(ButtonFactory().getGreenButton()) {
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    private lazy var stackView = build(UIStackView(arrangedSubviews: [currentLevelView, backButton, nextButton])) {
        $0.spacing = 10
        $0.axis = .horizontal
    }
    private var multiplier: CGFloat = 0
    private lazy var currentLevelWidth = currentLevelLine.widthAnchor.constraint(
        equalTo: backgroundLevelLine.widthAnchor,
        multiplier: multiplier
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        currentLevelView.addSubviews(currentLevelLabel, backgroundLevelLine, currentLevelLine)
        addSubview(stackView)
        setLayoutConstraints()
        stylize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        currentLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            currentLevelLabel.topAnchor.constraint(equalTo: currentLevelView.topAnchor, constant: 14),
            currentLevelLabel.leftAnchor.constraint(equalTo: currentLevelView.leftAnchor),
        ]
        
        backgroundLevelLine.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            backgroundLevelLine.topAnchor.constraint(equalTo: currentLevelLabel.bottomAnchor, constant: 12),
            backgroundLevelLine.bottomAnchor.constraint(equalTo: currentLevelView.bottomAnchor, constant: -14),
            backgroundLevelLine.leftAnchor.constraint(equalTo: currentLevelView.leftAnchor),
            backgroundLevelLine.rightAnchor.constraint(equalTo: currentLevelView.rightAnchor),
            backgroundLevelLine.heightAnchor.constraint(equalToConstant: 6)
        ]
        
        currentLevelLine.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            currentLevelLine.topAnchor.constraint(equalTo: backgroundLevelLine.topAnchor),
            currentLevelLine.bottomAnchor.constraint(equalTo: backgroundLevelLine.bottomAnchor),
            currentLevelLine.leftAnchor.constraint(equalTo: backgroundLevelLine.leftAnchor),
            currentLevelLine.heightAnchor.constraint(equalTo: backgroundLevelLine.heightAnchor)
        ]
        
        currentLevelView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            currentLevelView.topAnchor.constraint(equalTo: stackView.topAnchor),
            currentLevelView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            currentLevelView.leftAnchor.constraint(equalTo: stackView.leftAnchor)
        ]
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            backButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 14),
            backButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -14),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            nextButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 14),
            nextButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -14),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            nextButton.widthAnchor.constraint(equalToConstant: 132)
        ]
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func stylize() {
        currentLevelLabel.font = BaseFont.medium
        
        backgroundLevelLine.backgroundColor = BaseColor.base200
        backgroundLevelLine.layer.cornerRadius = 3
        
        currentLevelLine.backgroundColor = BaseColor.green500
        currentLevelLine.layer.cornerRadius = 3
    }
    
    func configure(currentLevel: Int, maxLevel: Int, delegate: InputLevelDelegate) {
        self.delegate = delegate
        
        let current = currentLevel + 1
        
        backButton.setEnabled(current != 1)
        backButton.isEnabled = current != 1
        
        let nextButtonTitle = current == maxLevel ? "Готово" : "Далее"
        nextButton.setTitle(nextButtonTitle, for: .normal)
        
        currentLevelLabel.text = current.description + " из " + maxLevel.description
        multiplier = CGFloat(Double(current) / Double(maxLevel))
        NSLayoutConstraint.activate([currentLevelWidth])
    }
    
    @objc private func backButtonTapped() {
        delegate?.onBackButtonClicked()
    }
    
    @objc private func nextButtonTapped() {
        delegate?.onNextButtonClicked()
    }
}
