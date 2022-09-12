//
//  JCLViewController.swift
//  MyFreedom
//
//  Created by Sanzhar on 01.07.2022.
//

import UIKit

class JCLViewController: BaseViewController {
    var router: JCLRouterInput?
    var interactor: JCLInteractorInput?
    
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
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }
        
        $0.register(BaseContainerCell<PDLimitsDisableView>.self)
        $0.register(BaseContainerCell<PDLimitsItemView>.self)
        $0.register(WrapperCell<AccessoryView>.self)
        $0.register(WrapperCell<SwitcherView<IndexPath>>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
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
        navigationSubtitleLabel.text = "Лимиты"
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

extension JCLViewController: JCLViewInput {
    func reloadData() {
        tableView.reloadData()
    }
    
    func update(at indexPath: IndexPath) {
        UIView.setAnimationsEnabled(false)
        tableView.reloadRows(at: [indexPath], with: .none)
        UIView.setAnimationsEnabled(true)
    }
    
    func presentBottomSheet(module: BaseDrawerContentViewControllerProtocol) {
        router?.presentBottomSheet(module: module)
    }
}

extension JCLViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.getSectionCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getItemCountIn(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.getItem(section: indexPath.section) else { return UITableViewCell() }
        
        switch item.id {
        case .limits:
            guard let limitModel = item.limits?[indexPath.row] else { return UITableViewCell() }
            
            let cell: BaseContainerCell<PDLimitsItemView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(viewModel: limitModel)
            cell.innerView.titleButton.actionClick = ActionClick(block: { [weak self] _ in
                self?.interactor?.presentLimitInfo()
            })
            return cell
        case .blockedPayments:
            let cell: WrapperCell<AccessoryView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.iconView.image = BaseImage.pdBlockedCard.uiImage
            cell.innerView.titleLabel.text = "Заблокированные платежи"
            cell.innerView.captionLabel.text = interactor?.getBlockedPaymentsCount().description
            cell.innerView.accessoryView.image = BaseImage.chevronRight.uiImage
            cell.changeSeparator(color: .clear)
            cell.selectionStyleIsEnabled = false
            return cell
        case .currencies:
            let cell: WrapperCell<SwitcherView<IndexPath>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.currencies?[indexPath.row].currencyType.title
            cell.innerView.iconView.image = item.currencies?[indexPath.row].currencyType.image
            cell.innerView.id = indexPath
            cell.innerView.isOn = item.currencies?[indexPath.row].isEnabled ?? true
            cell.innerView.delegate = self
            cell.changeSeparator(color: .clear)
            cell.selectionStyleIsEnabled = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getItem(section: section) else { return nil }
        
        switch item.id {
        case .currencies:
            let header: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
            header.innerView.set(text: item.header)
            return header
        case .blockedPayments:
            let header: WrapperHeaderFooterView<EmptyHeaderView> = tableView.dequeueReusableHeaderFooter()
            return header
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = interactor?.getItem(section: section) else { return nil }
        
        switch item.id {
        case .currencies, .blockedPayments:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = interactor?.getItem(section: indexPath.section) else { return }
        
        switch item.id {
        case .limits:
            router?.presentDetail()
        case .blockedPayments:
            router?.routeToBlockedPayments()
        default:
            break
        }
    }
}

extension JCLViewController: SwitchFieldViewDelegate {
    
    func switcher<ID>(isOn: Bool, forId id: ID) {
        guard let indexPath = id as? IndexPath else { return }
        interactor?.switcher(isOn: isOn, at: indexPath)
    }
}
