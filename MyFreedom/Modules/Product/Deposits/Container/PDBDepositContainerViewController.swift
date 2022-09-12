//
//  PDBDepositContainerViewController.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

class PDBDepositContainerViewController: BaseViewController {
    
    var router: PDBDepositContainerRouterInput?
    var interactor: PDBDepositContainerInteractorInput?

    private let refreshControl = UIRefreshControl()

    private lazy var tableView: UITableView = build(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isScrollEnabled = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.01))
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }
        
        $0.register(WrapperCell<AccessoryView>.self)
        $0.register(WrapperCell<RecentOperationsView>.self)
        $0.register(WrapperCell<SwitcherView<IndexPath>>.self)
        $0.register(BaseContainerCell<PDBannerView>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
        $0.register(BaseContainerCell<RemunerationForEntirePeriodView>.self)
    }
    
    private var backgroundView: UIView {
        let view = UIView()
        view.backgroundColor = BaseColor.base100
        return view
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addSubviews()
        setupLayout()
        setActions()
        
        interactor?.createElements()
    }

    private func configureView() {
        edgesForExtendedLayout = []
        view.backgroundColor = BaseColor.base100
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func setActions() {
        tableView.delegate = self
        tableView.dataSource = self
        
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

extension PDBDepositContainerViewController: PDBDepositContainerViewInput {

    func reloadData() {
        tableView.reloadData()
    }
    
    func update(at indexPath: IndexPath) {
        UIView.setAnimationsEnabled(false)
        tableView.reloadRows(at: [indexPath], with: .none)
        UIView.setAnimationsEnabled(true)
    }

    func routeToConditions() {
        router?.routeToConditions()
    }
    
    func routeToReference() {
        router?.routeToReference()
    }
    
    func routeToRequsites(viewModel: RequisiteViewModel) {
        router?.routeToRequsites(viewModel: viewModel)
    }

    func routeToDepositReward() {
        router?.routeToDepositReward()
    }
}

extension PDBDepositContainerViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        case .accessory:
            let cell: WrapperCell<AccessoryView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.iconView.image = item.image
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.subtitle
            cell.innerView.captionLabel.text = item.caption
            cell.innerView.accessoryView.image = item.accessory
            cell.changeSeparator(color: .clear)
            return cell
        case .recentOperations:
            let cell: WrapperCell<RecentOperationsView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.subtitle
            cell.innerView.iconView.image = item.image
            cell.innerView.descriptionLabel.text = item.caption
            if let modelAmout = item.amount {
                modelAmout.amount.visableAmount.map {
                    cell.innerView.amountLabel.text = $0 + " " + modelAmout.currency.symbol
                }

                cell.innerView.amountLabel.textColor = BaseColor.base500
            }
            if !item.showSeparator {
                cell.changeSeparator(color: .clear)
            }
            return cell
        case .pdBanner(let items):
            let cell: BaseContainerCell<PDBannerView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(items: items)
            cell.innerView.delegate = self
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
            cell.innerView.isEnabled = item.isEnabled
            cell.selectionStyleIsEnabled = false
            return cell
        case .remunaration:
            let cell: BaseContainerCell<RemunerationForEntirePeriodView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.subtitle
            cell.innerView.percentLabel.text = "13,5%"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        switch item.id {
        case .settings:
            let header: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
            header.innerView.set(text: item.title)
            let view = UIView()
            view.backgroundColor = BaseColor.base100
            header.backgroundView = view
            return header
        case .recentOperations:
            let header: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
            header.innerView.set(text: item.title)
            let view = UIView()
            view.backgroundColor = BaseColor.base100
            header.backgroundView = view
            header.innerView.button.setTitle("Все", for: .normal)
            header.innerView.rightButtonAction = { print(1234) }
            return header
        case .detail:
            let header: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
            header.innerView.set(text: item.title)
            let view = UIView()
            view.backgroundColor = BaseColor.base100
            header.backgroundView = view
            return header
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        switch item.id {
        case .settings, .detail, .recentOperations:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            let view = UIView()
            view.backgroundColor = BaseColor.base100
            footer.backgroundView = view
            return footer
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let item = interactor?.getSectiontBy(section: section) else { return 0 }
        switch item.id {
        case .settings, .detail, .recentOperations:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor?.didSelectItem(at: indexPath)
    }
}

extension PDBDepositContainerViewController: SwitchFieldViewDelegate {
    
    func switcher<ID>(isOn: Bool, forId id: ID) {
        guard let indexPath = id as? IndexPath else { return }
        interactor?.switcher(isOn: isOn, at: indexPath)
    }
}

extension PDBDepositContainerViewController: PDBannerViewDelegate {
    
    func didSelectItem(at indexPath: IndexPath) { }
}

// MARK: - BSheetScrollProtocol
extension PDBDepositContainerViewController {
    
    var contentScrollView: UIScrollView { tableView }
}
