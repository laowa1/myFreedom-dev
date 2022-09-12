//
//  DigitalDocumentsViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 18.05.2022.
//

import UIKit
import WebKit

class DigitalDocumentsViewController: BaseViewController {

    var router: DigitalDocumentsRouter?
    var interactor: DigitalDocumentsInteractorInput?

    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))

    private lazy var shareDocumentButton: UIBarButtonItem = .init(image: BaseImage.share.uiImage,
                                                                                     style: .plain,
                                                                                     target: self,
                                                                                     action: #selector(shareDigitalDocument))
    private lazy var webViewContent: WKWebView = build {
        $0.backgroundColor = .clear
        $0.navigationDelegate = self
    }

    private let qrScanerButton: UIButton = build(ButtonFactory().getGreenButton(cornerRadius: 16)) {
        $0.setTitle("Показать с QR", for: .normal)
        $0.setImage(BaseImage.scaner.uiImage, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        addSubviews()
        setupLayout()

        interactor?.loadContent()
    }

    private func configureView() {
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = goBackButton
        goBackButton.tintColor = BaseColor.base900
        navigationItem.rightBarButtonItem = shareDocumentButton
        goBackButton.tintColor = BaseColor.base900

        qrScanerButton.addTarget(self, action: #selector(QRScaner), for: .touchUpInside)
    }

    private func addSubviews() {
        view.addSubview(webViewContent)
        view.addSubview(qrScanerButton)
    }

    private func setupLayout() {
        var layoutContraints = [NSLayoutConstraint]()

        webViewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints += webViewContent.getLayoutConstraints(over: view)

        qrScanerButton.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints += [
            qrScanerButton.heightAnchor.constraint(equalToConstant: 52),
            qrScanerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46),
            qrScanerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            qrScanerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]

        NSLayoutConstraint.activate(layoutContraints)
    }

    @objc private func QRScaner() { }

    @objc private func backButtonAction() {
        router?.routeToBack()
    }

    @objc private func shareDigitalDocument() { }
}

extension DigitalDocumentsViewController: DigitalDocumentsViewInput {

    func set(title: String?, url: URL) {
        self.title = title
        webViewContent.load(URLRequest(url: url))
    }
}

extension DigitalDocumentsViewController: WKNavigationDelegate { }
