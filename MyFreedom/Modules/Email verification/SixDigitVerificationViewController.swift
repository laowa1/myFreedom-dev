//
//  EmailVerificationViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 5/13/22.
//

import Foundation
import UIKit

class SixDigitVerificationViewController: BaseViewController {

    var router: SixDigitVerififcationRouterInput?
    var interactor: SixDigitVerificationInteractorInput?

    private let navigationTitle = "Код-подтверждение"
    private lazy var subtitleLabel: PaddingLabel = build {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.regular.withSize(17)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.insets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    private var spaceView: UIView = build {
        $0.frame.size.height = 16
    }
    private lazy var otpContainer: UIView = build {
        $0.addSubview(otpStackview)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    private lazy var otpStackview: OPTStackViewHyphen = build {
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    private var bottomSpaceView: UIView = build {
        $0.frame.size.height = 16
    }
    private lazy var bottomStack: UIStackView = build {
        $0.addArrangedSubviews([errorLabel, sendAgainMessageLabel, sendAgainButton])
        $0.axis = .vertical
        $0.spacing = 32
    }
    private lazy var errorLabel: UILabel = build {
        $0.text = "Неверный код, попробуйте еще раз"
        $0.textColor = BaseColor.red700
        $0.font = BaseFont.regular.withSize(13)
        $0.isHidden = true
    }
    private lazy var sendAgainMessageLabel: UILabel = build {
        $0.font = BaseFont.regular
        $0.textAlignment = .left
    }
    private lazy var sendAgainButton: UIButton = build(ButtonFactory().getTextButton()) {
        $0.titleLabel?.font = BaseFont.regular
        $0.setTitle("Отправить код повторно", for: .normal)
        $0.setTitleColor(BaseColor.green500, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(sendCodeAgain), for: .touchUpInside)
        $0.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        interactor?.invalidateTimer()
    }

    private func configureSubviews () {
        title = " "
        navigationSubtitleLabel.text = navigationTitle
        subtitleLabel.text = "Введите 6-значный код, отправленный на Ваш email"
        view.backgroundColor = BaseColor.base50
        addSubviews()
        otpStackview.cleanCodeText()

        if let interactor = interactor {
            interactor.setResendTime()
            interactor.runTimer()
        }
    }

    private func addSubviews() {
        contentStack.addArrangedSubviews([subtitleLabel, spaceView, otpContainer, bottomSpaceView, bottomStack])
    }

    @objc private func sendCodeAgain() {
        guard let interactor = interactor else { return }
        interactor.runTimer()
        router?.resend(id: interactor.getId())
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setErrorState() {
        bottomSpaceView.isHidden = true
        errorLabel.isHidden = false
        otpStackview.error()
    }
}

extension SixDigitVerificationViewController: SixDigitVerificationViewInput {

    func set(resendTime: TimeInterval) {
        let text = "Отправить код повторно через "
        let attributedText = NSMutableAttributedString(string: text)
        let attributedTimeText = NSMutableAttributedString(string: resendTime.timerString)
        attributedText.setAttributes([.font: BaseFont.regular, .foregroundColor: BaseColor.base700], range: NSRange(location: 0, length: text.count))
        attributedTimeText.setAttributes([.font: BaseFont.regular, .foregroundColor: BaseColor.green500], range: NSRange(location: 0, length: resendTime.timerString.count))
        attributedText.append(attributedTimeText)
        sendAgainMessageLabel.attributedText = attributedText
    }

    func setResendState(enabled: Bool) {
        errorLabel.isHidden = true
        bottomSpaceView.isHidden = false
        sendAgainMessageLabel.isHidden = enabled
        sendAgainButton.isHidden = !enabled
    }

    func confirm() {
        guard let interactor = interactor else { return }
        router?.confirm(id: interactor.getId())
    }

    func fail(message: String) {
        interactor?.setResendTime()
        setErrorState()

        guard let interactor = interactor else { return }
        router?.fail(id: interactor.getId())
    }
}

extension SixDigitVerificationViewController: OTPProtocol {
    func didChange(code: String) {
        if code == "888888" {
            setErrorState()
        } else if code == "111111" {
            guard interactor != nil else { return }

            view.endEditing(true)
            otpStackview.removeBorder()
            showLoader()
            router?.confirm(id: interactor?.getId() ?? UUID())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: { [weak self] in
                self?.hideLoader()
            })
        } else {
            errorLabel.isHidden = true
            bottomSpaceView.isHidden = false
            otpStackview.removeBorder()
        }
    }

    
}


