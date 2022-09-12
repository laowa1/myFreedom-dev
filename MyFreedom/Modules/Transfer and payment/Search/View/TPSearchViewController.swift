//
//  TPSearchViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

class TPSearchViewController: BaseTableViewController {

    var router: TPSearchRouter?
    var interactor: TPSearchInteractorInput?
    
    private var currentItemFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Переводы и платежи"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        configureSubviews()
        addActions()

        interactor?.createElements()
    }

    override func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        navigationController.setNavigationBarHidden(false, animated: false)
    }

    private func addActions() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configureSubviews() {
        tableView.backgroundColor = BaseColor.base100
        tableView.separatorStyle = .none
        tableView.tableFooterView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.01))
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }

        tableView.register(WrapperCell<RecentOperationsView>.self)
        tableView.register(WrapperCell<TPRecentRequestsView>.self)
        tableView.register(BaseContainerCell<TPEmptySearchView>.self)
        tableView.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        tableView.register(WrapperHeaderFooterView<EmptyFooterView>.self)
    }
}

extension TPSearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.getSectionsCount() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getCountBy(section: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.getElementBy(indexPath: indexPath) else {
            return UITableViewCell()
        }

        switch item.fieldType {
        case .history:
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
        case .recentRequests:
            let cell: WrapperCell<TPRecentRequestsView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.itemIcon.image = item.image
            cell.innerView.itemTitle.text = item.title
            if !item.showSeparator {
                cell.changeSeparator(color: .clear)
            }
            return cell
        case .searchEmpty:
            let cell: BaseContainerCell<TPEmptySearchView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.subtitle
            cell.innerView.layer.cornerRadius = 16
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        let header: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
        header.innerView.set(text: item.title)
        header.innerView.button.setTitle(item.buttonTitle, for: .normal)
        header.innerView.rightButtonAction = { }
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section) else { return nil }
        if item.id == .recentRequests || item.id == .publicServices {
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        interactor?.didSelectItem(at: indexPath)
    }
}

extension TPSearchViewController: TPSearchViewInput {
    
    func reload() {
        tableView.reloadData()
    }
}

extension TPSearchViewController {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.searchTextDidChange(text: searchText)
    }

    func updateSearchResults(for searchController: UISearchController) { }
}
