//
//  JCOpenViewContoller.swift
//  MyFreedom
//
//  Created by &&TairoV on 04.07.2022.
//

import UIKit

protocol JCOpenViewInput: BaseViewControllerProtocol {
    func nextButton(hide: Bool)
    func popToRoot()
    func routeToChooseChild(module: SingleSelectionViewInput)
    func routeToEPContacts(module: EPContactsPickerViewInput)
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
    func routeToOtp(phone: String)
    func routeToBack()
    func reload()
}

class JCOpenViewController: BaseViewController {

    enum TextFieldId: Int {
        case name = 0, phoneNumber
    }

    var interactor: JCOpenInteractorInput?
    var router: JCOpenRouterInput?

    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))

    private let tableView: UITableView = build(UITableView(frame: .zero, style: .plain)) {
        $0.backgroundColor = BaseColor.base100
        $0.separatorStyle = .none
        $0.tableHeaderView = nil
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.keyboardDismissMode = .onDrag
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }

        $0.register(BaseContainerCell<TPTitleTextFieldView<TextFieldId>>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
    }

    private let nextButton: UIButton = build {
        $0.backgroundColor = BaseColor.green500
        $0.layer.cornerRadius = 16
        $0.setTitle("Продолжить", for: .normal)
        $0.isHidden = true
        $0.titleLabel?.font = BaseFont.semibold.withSize(18)
        $0.setTitleColor(BaseColor.base50, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        addSubviews()
        setupLayout()
        addActions()

        interactor?.createElements()
    }

    private func configureSubviews() {
        navigationItem.leftBarButtonItem = goBackButton
        goBackButton.tintColor = BaseColor.base900
        view.backgroundColor = BaseColor.base100
        title = "Открыть Детскую карту"

        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    private func addSubviews() {
        view.addSubviews(tableView, nextButton)
    }

    private func setupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += tableView.getLayoutConstraints(over: view, safe: false)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -52),
            nextButton.heightAnchor.constraint(equalToConstant: 52)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func addActions() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc private func backButtonAction() {
        router?.routeToBack()
    }

    @objc func nextButtonTapped() {
        interactor?.continueTapped()
    }
}

extension JCOpenViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.getSectionsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getCountBy(section: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let item = interactor?.getElementBy(id: indexPath) else {
            return UITableViewCell()
        }

        switch item.fieldType {
        case .name:
            let cell: BaseContainerCell<TPTitleTextFieldView<TextFieldId>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.title = item.title
            cell.innerView.textField.font = BaseFont.regular.withSize(16)
            cell.innerView.placeholder = item.description ?? ""
            cell.innerView.textField.text = interactor?.getSelectedValue(item: item.fieldType)
            cell.innerView.delegate = self
            cell.innerView.id = .name
            cell.innerView.isEditable = false
            cell.innerView.set(auxilaryButtonImage: item.image)
            return cell
        case .phoneNumber:
            let cell: BaseContainerCell<TPTitleTextFieldView<TextFieldId>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.title = item.title
            cell.innerView.textField.font = BaseFont.regular.withSize(16)
            cell.innerView.placeholder = item.description ?? ""
            cell.innerView.textField.text = interactor?.getSelectedValue(item: item.fieldType)
            cell.innerView.keyboardType = .numberPad
            cell.innerView.maskFormat = Constants.phoneMask
            cell.innerView.delegate = self
            cell.innerView.textField.addDoneButtonOnKeyboard()
            cell.innerView.id = .phoneNumber
            cell.innerView.isEditable = true
            cell.innerView.set(auxilaryButtonImage: item.image)
            return cell
        }
    }
}

extension JCOpenViewController: JCOpenViewInput {

    func routeToEPContacts(module: EPContactsPickerViewInput) {
        router?.routeToEPContacts(module: module)
    }

    func reload() {
        tableView.reloadData()
    }

    func routeToBack() {
        router?.routeToBack()
    }

    func routeToChooseChild(module: SingleSelectionViewInput) {
        router?.routeToChooseChild(module: module)
    }

    func routeToOtp(phone: String) {
        router?.routeToOtp(phone: phone)
    }

    func popToRoot() {
        router?.popToRoot()
    }

    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate) {
        router?.routeToInformConfirmIdentity(model: model, delegate: delegate)
    }

    func nextButton(hide: Bool) {
        nextButton.isHidden = hide
    }

}

extension JCOpenViewController: TPTextFieldViewDelegate {

    func didSelectView<ID>(at id: ID) {
        guard let fieldId = id as? TextFieldId else { return }
        interactor?.didSelectItem(at: fieldId.rawValue)
    }

    func didPressAuxilaryButton<ID>(forId id: ID) {
        guard let fieldId = id as? TextFieldId else { return }
        interactor?.didSelectItem(at: fieldId.rawValue)
    }

    func didBeginEditing<ID>(text: String, forId id: ID) {
        guard let fieldId = id as? TextFieldId else { return }
        switch fieldId {
        case .name:
            print("Witched name")
        default: return
        }
    }
}
