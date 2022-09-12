//
//  DepositRenameViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 27.06.2022.
//

import UIKit

protocol DepositRenameViewInput: BaseViewControllerProtocol { }

class DepositRenameViewController: BaseViewController {

    var router: DepositRenameRouterInput?
    var interactor: DepositRenameInteractorInput?
    override var baseModalPresentationStyle: UIModalPresentationStyle { .overFullScreen }
    let maxLength = 150
    private lazy var availabla =  "\(maxLength - textView.text.count)"

    private lazy var toolbar: UIToolbar = build {
        $0.sizeToFit()
        $0.items = [flexbleSpace, barButton]
    }

    private lazy var barButton: UIBarButtonItem = build {
        $0.tintColor = BaseColor.base100
    }
    private lazy var flexbleSpace =  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

    private var cancelButton: UIButton = build {
        $0.backgroundColor = BaseColor.base50
        $0.setTitleColor(BaseColor.base800, for: .normal)
        $0.titleLabel?.font = BaseFont.medium.withSize(13)
        $0.layer.cornerRadius = 16
        $0.contentEdgeInsets = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        $0.setTitle("Отмена", for: .normal)
    }

    private var doneButton: UIButton = build {
        $0.backgroundColor = BaseColor.green500
        $0.setTitleColor(BaseColor.base50, for: .normal)
        $0.titleLabel?.font = BaseFont.medium.withSize(13)
        $0.layer.cornerRadius = 16
        $0.contentEdgeInsets = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        $0.setTitle("Готово", for: .normal)
    }

    private lazy var textView: UITextView = build {
        $0.inputAccessoryView = toolbar
        $0.autocorrectionType = .no
        $0.backgroundColor = .clear
        $0.tintColor = BaseColor.green500
        $0.font = BaseFont.bold.withSize(28)
        $0.textColor = BaseColor.base50
        $0.textContainerInset = UIEdgeInsets.zero
        $0.textContainer.lineFragmentPadding = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        addSubviews()
        setuplayout()
    }

    @objc func cancelAction() {
        router?.routeToBack()
    }

    @objc func doneAction() {
        router?.routeToBack()
    }

    private func configureSubviews() {
        view.addBlur(style: .dark)
        view.backgroundColor = .clear

        textView.delegate = self
        textView.becomeFirstResponder()
        textView.text = interactor?.getDepositName()

        barButton.title = "\(maxLength - textView.text.count)"

        cancelButton.addTarget(self, action:#selector(cancelAction), for: .touchUpInside)
        doneButton.addTarget(self, action:#selector(doneAction), for: .touchUpInside)
    }

    private func addSubviews() {
        view.addSubview(cancelButton)
        view.addSubview(doneButton)
        view.addSubview(textView)
    }

    private func setuplayout() {
        var layoutConstraints  = [NSLayoutConstraint]()

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ]

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            doneButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]

        textView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            textView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 24),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension DepositRenameViewController: DepositRenameViewInput {}

extension DepositRenameViewController: UITextViewDelegate {

        func textViewDidChange(_ textView: UITextView) {
            barButton.title = "\(maxLength - textView.text.count)"
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return textView.text.count + (text.count - range.length) <= maxLength
        }
}
