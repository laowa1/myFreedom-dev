//
//  PDBAccountContainerViewController.swift
//  MyFreedom
//
//  Created by m1pro on 29.05.2022.
//

import UIKit

class PDBAccountContainerViewController: BaseViewController {
    
    var router: PDBAccountContainerRouterInput?
    var interactor: PDBAccountContainerInteractorInput?

    private let refreshControl = UIRefreshControl()

    private lazy var tableView: UITableView = build(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isScrollEnabled = false

        $0.register(WrapperCell<AccessoryView>.self)
        $0.register(WrapperCell<SwitcherView<IndexPath>>.self)
        $0.register(BaseContainerCell<PDBannerView>.self)
        $0.register(WrapperCell<RecentOperationsView>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
        $0.register(BaseContainerCell<RemunerationForEntirePeriodView>.self)
        
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }
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

extension PDBAccountContainerViewController: PDBAccountContainerViewInput {

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
}

extension PDBAccountContainerViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        interactor?.didSelectItem(at: indexPath)
    }
}

// MARK: - BSheetScrollProtocol
extension PDBAccountContainerViewController {
    
    var contentScrollView: UIScrollView { tableView }
}
