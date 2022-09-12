//
//  OrderCardViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit

class OrderPlasticCardViewController: BaseViewController {
    
    var router: OrderPlasticCardRouterInput?
    var interactor: OrderPlasticCardInteractorInput?
    
    enum TextFieldId: Int {
        case street = 0, office, entrance, city, details
    }
    
    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    
    lazy var button: BaseButton = build(ButtonFactory().getGreenButton(cornerRadius: 16)) {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = BaseFont.semibold.withSize(18)
        $0.setTitle("Заказать пластиковую карту", for: .normal)
    }
    
    private let tableView: UITableView = build(UITableView(frame: .zero, style: .plain)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableHeaderView = nil
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
        
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
        $0.register(BaseContainerCell<InfoTextView>.self)
        $0.register(WrapperCell<OrderPlasticTextField<TextFieldId>>.self)
        $0.register(WrapperCell<TPTitleTextFieldView<TextFieldId>>.self)
        $0.register(WrapperCell<BaseTwoInputView<TextFieldId>>.self)
        
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        addSubviews()
        setupLayout()
        setActions()
        
        interactor?.createElements()
    }
    
    private func configureView() {
        navigationItem.leftBarButtonItem = goBackButton
        goBackButton.tintColor = BaseColor.base900
        view.backgroundColor = BaseColor.base100
        navigationSubtitleLabel.text = "Заказать пластиковую карту"
    }
    
    private func addSubviews() {
        view.addSubview(button)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: navigationSubtitleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor)
        ]
        
        button.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            button.heightAnchor.constraint(equalToConstant: 52),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func setActions() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func backButtonAction() {
        router?.routeToBack()
    }
}

extension OrderPlasticCardViewController: OrderPlasticCardViewInput {
    func reload() {
        tableView.reloadData()
    }
    
    func reloadCell(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension OrderPlasticCardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.getSectionCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getItemCountIn(section: section)  ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.getItemBy(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        switch item.fieldType {
        case .info :
            let cell: BaseContainerCell<InfoTextView> =  tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.textView.text = item.description
            return cell
        case .city:
            let cell: WrapperCell<OrderPlasticTextField<TextFieldId>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.title = item.title ?? ""
            cell.innerView.isEditable = false
            cell.innerView.textField.font = BaseFont.regular.withSize(16)
            cell.innerView.textField.textColor = BaseColor.base900
            cell.innerView.textField.text = item.description
            cell.innerView.set(auxilaryButtonImage: item.icon)
            cell.changeSeparator(color: .clear)
            return cell
        case .street:
            let cell: WrapperCell<TPTitleTextFieldView<TextFieldId>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.title = item.title ?? ""
            cell.innerView.textField.font = BaseFont.regular.withSize(16)
            cell.innerView.placeholder = item.description ?? ""
            cell.innerView.delegate = self
            cell.changeSeparator(color: .clear)
            cell.innerView.id = .street
            cell.innerView.isEditable = false
            cell.innerView.textField.text = item.text
            return cell
        case .flat( let flat, let flatValue, let entrance, let entranceValue):
            let cell: WrapperCell<BaseTwoInputView<TextFieldId>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.firstTextField.title = flat
            cell.innerView.firstTextField.placeholder = item.description ?? ""
            cell.innerView.firstTextField.id = .office
            cell.innerView.firstTextField.delegate = self
            cell.innerView.firstTextField.isEditable = false
            cell.innerView.firstTextField.textField.text = flatValue
            cell.innerView.secondTextField.title = entrance
            cell.innerView.secondTextField.placeholder = item.description ?? ""
            cell.innerView.secondTextField.id = .entrance
            cell.innerView.secondTextField.delegate = self
            cell.innerView.secondTextField.isEditable = false
            cell.innerView.secondTextField.textField.text = entranceValue
            cell.changeSeparator(color: .clear)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        switch item.id {
        case .address :
            let footer: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        switch item.id {
        case .address:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return 0 }
        switch item.id {
        case .info: return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return 0 }
        switch item.id {
        case .info: return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        interactor?.didSelectItem(at: indexPath)
    }
}

extension OrderPlasticCardViewController: TPTextFieldViewDelegate {
    
    func didSelectView<ID>(at id: ID) {
        guard let id = id as? TextFieldId,
              let model = interactor?.getModel(currentLevelIndex: id.rawValue)
        else { return }
        router?.routeToInput(model: model)
    }
}
