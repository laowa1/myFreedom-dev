//
//  InformPopUpViewController.swift
//  MyFreedom
//
//  Created by Sanzhar on 11.03.2022.
//

import UIKit

final class InformPopUpViewController: BaseViewController {
    
    var router: InformPopUpRouterInput?
    
    private var id: UUID?
    private var url: String?
    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    private let subtitleLabel: UILabel = build {
        let width: CGFloat = UIScreen.main.bounds.height > 700 ? 16 : 14
        $0.font = BaseFont.regular.withSize(width)
        $0.textColor = BaseColor.base700
        $0.numberOfLines = 0
    }
    private lazy var linkButton = build(ButtonFactory().getWhiteButton()) {
        $0.isHidden = true
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.lineBreakMode = .byWordWrapping
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.8
    }
    private let imageView = UIImageView()
    private let buttonsStack: UIStackView = build {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BaseColor.base50
        configureSubviews()
        setupLayout()
    }
    
    private func configureSubviews() {
        navigationItem.leftBarButtonItem = goBackButton
        addToStack(subtitleLabel)
        addToStack(linkButton)
        view.addSubview(imageView)
        view.addSubview(buttonsStack)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.topAnchor.constraint(lessThanOrEqualTo: contentStack.bottomAnchor, constant: 56),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 320/290)
        ]
        
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            buttonsStack.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: 10),
            buttonsStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            buttonsStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func configure(model: InformPUViewModel?) {
        self.id = model?.id
        if model?.hiddenBack == true {
            navigationItem.setHidesBackButton(true, animated: true)
        }
        
        navigationSubtitleLabel.attributedText = model?.titleText
        if model?.url != nil, model?.urlTitle != nil {
            url = model?.url
            linkButton.setTitle(model?.urlTitle, for: .normal)
            linkButton.addTarget(self, action: #selector(linkButtonAction), for: .touchUpInside)
            linkButton.isHidden = false
        }
        title = " "
        subtitleLabel.text = model?.subtitleText
        imageView.image = model?.image.uiImage
        
        model?.buttons.forEach {
            let button: BaseButton
            if $0.type == .destructive {
                button = ButtonFactory().getNotAcceptButton()
            } else {
                button = $0.isGreen ? ButtonFactory().getGreenButton() : ButtonFactory().getWhiteButton()
            }
            button.setTitle($0.title, for: .normal)
            button.tag = $0.type.rawValue
            let height: CGFloat = $0.isGreen ? 52 : 20
            button.heightAnchor.constraint(equalToConstant: height).isActive = true
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            buttonsStack.addArrangedSubviews(button)
        }
    }
    
    @objc private func linkButtonAction() {
        guard let urlString = url,
              let url = URL(string: urlString) else { return }
        
        router?.routeToWebview(title: subtitleLabel.text ?? "", url: url)
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        guard let id = id, let type = InformPUButtonType(rawValue: sender.tag) else { return }
        
        router?.buttonAction(type: type, id: id)
    }

    @objc private func backButtonAction() {
        router?.routeToBack()
    }
}

extension InformPopUpViewController: InformPopUpViewInput { }
