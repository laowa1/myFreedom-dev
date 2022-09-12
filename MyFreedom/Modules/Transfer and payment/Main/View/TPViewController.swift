//
//  TPViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

class TPViewController: BaseTableViewController {

    var router: TPRouter?
    var interactor: TPInteractorInput?
    var searchViewContoller: TPSearchViewInput?


    private lazy var searchController = build(CustomSearchContoller(searchResultsController: searchViewContoller)) {
        if let textfield = $0.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = BaseColor.base200
            textfield.font = BaseFont.regular.withSize(16)
            textfield.clearButtonMode = .whileEditing
            textfield.leftViewMode = .always
            textfield.tintColor = BaseColor.green500
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = BaseColor.base400
            }
        }

        $0.searchBar.delegate = searchViewContoller
        $0.searchBar.backgroundImage = UIImage()
        $0.searchBar.placeholder = "Поиск"
        $0.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        $0.searchResultsUpdater = searchViewContoller
        $0.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }

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
        tableView.register(ContentHeaderFooterView<TPHeaderView>.self)
        tableView.register(WrapperHeaderFooterView<EmptyFooterView>.self)
        tableView.register(BaseContainerCell<TPFavouritesBannerView>.self)
        tableView.register(BaseContainerCell<TPHorizontalBannerView>.self)

        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension TPViewController {
    
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

            if indexPath.row == 0 {
                cell.cornerTopRadius(radius: 16)
            }
            return cell
        case .transfers(let items), .payments(let items), .publicServices(let items):
            let cell: BaseContainerCell<TPHorizontalBannerView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(items: items)
            return cell
        case .favourites(let items):
            let cell: BaseContainerCell<TPFavouritesBannerView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(items: items)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        let header: ContentHeaderFooterView<TPHeaderView> = tableView.dequeueReusableHeaderFooter()
        header.innerView.set(text: item.title)
        header.innerView.button.setTitle(item.buttonTitle, for: .normal)
        header.innerView.rightButtonAction = { [weak self] in
            self?.interactor?.didSelectShowAll(at: section)
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.id == .history else { return nil }
        let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
        return footer
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let item = interactor?.getSectiontBy(section: section) else { return 0 }
        switch item.id {
        case .history:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        interactor?.didSelectItem(at: indexPath)
    }
}

extension TPViewController: TPViewInput {
    
    func reload() {
        tableView.reloadData()
    }

    func routeToTransfers() {
        router?.routeToTransfers()
    }

    func routeToFavorites() {
        router?.routeToFavorites()
    }
}

extension TPViewController: BaseTabBarPresentable {

    var baseTabBarItem: BaseTabBarItem {
        let tabBarItem = BaseTabBarItem()
        title = "Платежи"
        tabBarItem.title = title
        tabBarItem.icon = BaseImage.pt.uiImage
        return tabBarItem
    }
}
