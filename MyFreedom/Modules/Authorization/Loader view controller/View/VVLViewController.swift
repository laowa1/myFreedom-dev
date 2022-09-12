//
//  VVLViewController.swift
//  MyFreedom
//
//  Created by Sanzhar on 12.04.2022.
//

import UIKit

protocol VVLViewInput: BaseViewController { }

final class VVLViewController: BaseViewController {
    
    var router: VVLRouterInput?
    private lazy var spinnerBackgroundView: UIView = build {
        $0.backgroundColor = BaseColor.base50
        $0.layer.cornerRadius = 80
        $0.clipsToBounds = true
    }
    private lazy var spinnerView = SpinnerView()
    private lazy var doneImage: UIImageView = build {
        $0.image = BaseImage.loaderDone.uiImage?.resized(to: CGSize(width: 160, height: 160))
        $0.contentMode = .scaleAspectFill
        $0.isHidden = true
    }
    private lazy var progressLabel: UILabel = build {
        $0.font = BaseFont.bold.withSize(28)
        $0.text = "10%"
        $0.textColor = BaseColor.green500
    }
    
    private lazy var verticalStack: UIStackView = build {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
        $0.addArrangedSubviews(descriptionTitle, descriptionSubtitle)
    }
    private lazy var descriptionTitle: UILabel = build {
        $0.font = BaseFont.bold.withSize(28)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private lazy var descriptionSubtitle: UILabel = build {
        $0.font = BaseFont.regular
        $0.numberOfLines = 0
        $0.text = "Пожалуйста, не закрывайте приложение"
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BaseColor.base50
        
        configureSubviews()
        setLayoutConstraints()
        
        start()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.progressLabel.text = "50%"
            self?.mid()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.progressLabel.text = "100%"
                self?.end()
            }
        }
    }
    
    private func configureSubviews() {
        spinnerView.addSubview(progressLabel)
        spinnerBackgroundView.layer.applyShadow(color: BaseColor.base900, alpha: 0.05)
        spinnerBackgroundView.addSubview(spinnerView)
        spinnerBackgroundView.addSubview(doneImage)
        view.addSubview(spinnerBackgroundView)
        view.addSubview(verticalStack)
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
                
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += spinnerView.getLayoutConstraints(over: spinnerBackgroundView, margin: 26.5)
        
        doneImage.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += doneImage.getLayoutConstraints(over: spinnerBackgroundView)
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            progressLabel.centerXAnchor.constraint(equalTo: spinnerBackgroundView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: spinnerBackgroundView.centerYAnchor)
        ]
        
        spinnerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            spinnerBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerBackgroundView.widthAnchor.constraint(equalToConstant: 160),
            spinnerBackgroundView.heightAnchor.constraint(equalToConstant: 160),
            spinnerBackgroundView.bottomAnchor.constraint(equalTo: verticalStack.topAnchor, constant: -24)
        ]
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            verticalStack.topAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23.5),
            verticalStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23.5)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func start() {
        spinnerView.animate()
        descriptionTitle.text = "Проверяем..."
    }
    
    private func mid() {
        descriptionTitle.text = "Выпускаем для Вас  облачное ЭЦП..."
    }
    
    private func end() {
        spinnerView.removeFromSuperview()
        doneImage.isHidden = false
        descriptionTitle.text = "Готово"
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        router?.nextPage()
//        }
    }
}

extension VVLViewController: VVLViewInput { }
