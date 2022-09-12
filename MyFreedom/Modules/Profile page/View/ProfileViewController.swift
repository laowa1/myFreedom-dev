//
//  PrfileViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 06.05.2022.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    var router: ProfileRouterInput?
    var interactor: ProfileInteractorInput?
    
    private var currentItemFrame: CGRect?
    private let refreshControl = UIRefreshControl()
    
    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    
    private let tableView: UITableView = build(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableHeaderView = nil
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        
        $0.register(WrapperCell<AccessoryView>.self)
        $0.register(WrapperCell<SwitcherView<IndexPath>>.self)
        $0.register(BaseContainerCell<PrimaryButtonView<IndexPath>>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
        $0.register(BaseContainerCell<DigitalDocumentsView>.self)
        $0.register(BaseContainerCell<DigitalDocumentsActivateView>.self)
        $0.register(BaseContainerCell<DigitalDocumentsUnavailableView>.self)
        
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
        navigationSubtitleLabel.text = "Профиль"
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: navigationSubtitleLabel.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func setActions() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func backButtonAction() {
        router?.popViewContoller()
    }
    
    @objc func refreshData() {
        update(at: IndexPath(item: 0, section: 0))
        refreshControl.endRefreshing()
    }
}

extension ProfileViewController: ProfileViewInput {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func update(at indexPath: IndexPath) {
        UIView.setAnimationsEnabled(false)
        tableView.reloadRows(at: [indexPath], with: .none)
        UIView.setAnimationsEnabled(true)
    }
    
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol) {
        router?.presentDocumentList(module: module)
    }
    
    func updateAllViews() {
        router?.updateAllViews()
    }
    
    func routeToEnterCurrentAC(type: String, delegate: AccessCodeConfirmFaceDelegate) {
        router?.routeToEnterCurrentAC(type: type, delegate: delegate)
    }
    
    func routeToChangeAC(delegate: AccessCodeChangeDelegate) {
        router?.routeToChangeAC(delegate: delegate)
    }
    
    func routeChangeNumber(delegate: ChangePhoneDelegate) {
        router?.routeChangeNumber(delegate: delegate)
    }
    
    func routeToAddEmail(delegate: AddEmailDelegate) {
        router?.routeToAddEmail(delegate: delegate)
    }
    
    func routeToActivateDigitalDocuments() {
        router?.routeToActivateDigitalDocument()
    }
    
    func routeToDigitalDocumentStories() {
        router?.routeToDigitalDocumentStories()
    }
    
    func routeToDigitalDocument() {
        
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        switch item.filedType {
        case .digitalDocuments:
            let digitalDocumentCell: BaseContainerCell<DigitalDocumentsView> =  tableView.dequeueReusableCell(for: indexPath)
            digitalDocumentCell.innerView.delegate = self
            let activateCell: BaseContainerCell<DigitalDocumentsActivateView> =  tableView.dequeueReusableCell(for: indexPath)
            activateCell.innerView.delegate = self
            let unavailableCell: BaseContainerCell<DigitalDocumentsUnavailableView> =  tableView.dequeueReusableCell(for: indexPath)

            guard let cell = interactor?.getDigitalDocumentCell(from: [digitalDocumentCell, activateCell, unavailableCell]) else {
                return UITableViewCell()
            }
            
            return cell
        case .accessory:
            let cell: WrapperCell<AccessoryView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.iconView.image = item.image
            cell.innerView.titleLabel.text = item.title
            cell.innerView.captionLabel.text = item.caption
            cell.innerView.accessoryView.image = item.accessory
            cell.changeSeparator(color: .clear)
            return cell
        case .switcher(let isOn):
            let cell: WrapperCell<SwitcherView<IndexPath>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subitleLabel.text = item.subtitle
            cell.innerView.iconView.image = item.image
            cell.changeSeparator(color: .clear)
            cell.innerView.id = indexPath
            cell.innerView.isOn = isOn
            cell.innerView.delegate = self
            return cell
        case .button:
            let cell: BaseContainerCell<PrimaryButtonView<IndexPath>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.button.backgroundColor = BaseColor.base200
            cell.innerView.button.setTitleColor(.black, for: .normal)
            cell.innerView.button.setTitle(item.title, for: .normal)
            cell.innerView.delegate = self
            cell.innerView.button.layer.cornerRadius = 16
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        switch item.id {
        case .management, .security, .settings:
            let footer: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
            footer.innerView.set(text: item.title)
            return footer
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        switch item.id {
        case .management, .security, .settings:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        interactor?.didSelectItem(at: indexPath)
    }
}

extension ProfileViewController: PrimaryButtonViewDelegate {
    
    func didSelectButton() {
        showAlert(
            title: "Вы уверены, что хотите выйти?",
            message: nil,
            first: .init(title: "Отменить", style: .default, handler: nil),
            second: .init(title: "Да, выйти", style: .cancel, handler: { [weak self] _ in
                self?.interactor?.disablePasscodeUsage()
                self?.router?.closeSession()
            })
        )
    }
}

extension ProfileViewController: ActivateDigitalDocument, DigitalDocumentsViewDelegate {
    
    func tapActivate() {
        Bool.random() ? routeToActivateDigitalDocuments() : routeToDigitalDocumentStories()
    }
    
    func didSelectItem(at indexPath: IndexPath, currentItemFrame: CGRect?) {
        self.currentItemFrame = currentItemFrame
        guard let url = URL(string: "https://egov.kz/cms/ru") else { return }
        router?.routeToDigitalDocument(title: "Цифровые документы", url: url)
    }
    
}

extension ProfileViewController: SwitchFieldViewDelegate {
    
    func switcher<ID>(isOn: Bool, forId id: ID) {
        guard let indexPath = id as? IndexPath else { return }
        interactor?.switcher(isOn: isOn, at: indexPath)
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension ProfileViewController {
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard let currentItemFrame = self.currentItemFrame else { return nil }
        return GrowPresentAnimationController(originFrame: currentItemFrame)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let currentItemFrame = self.currentItemFrame else {
            return nil
        }
        return ShrinkDismissAnimationController(destinationFrame: currentItemFrame)
    }
}
