//
//  TransfersViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

class TransfersViewController: BaseTableViewController {

    var router: TransfersRouterInput?
    var interactor: TransfersInteractorInput?
    
    private var currentItemFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Переводы"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        configureSubviews()
        addActions()

        interactor?.createElements()
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

        tableView.register(WrapperCell<Accessory16MarginView>.self)
        tableView.register(WrapperCell<RecentOperationsView>.self)
        tableView.register(WrapperCell<TPRecentRequestsView>.self)
        tableView.register(BaseContainerCell<TPEmptySearchView>.self)
        tableView.register(ContentHeaderFooterView<TPHeaderView>.self)
        tableView.register(WrapperHeaderFooterView<EmptyFooterView>.self)
    }
}

extension TransfersViewController {
    
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
        case .accessory:
            let cell: WrapperCell<Accessory16MarginView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.iconView.image = item.image
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.subtitle
            cell.innerView.captionLabel.text = item.caption
            cell.innerView.accessoryView.image = item.accessory

            if !item.showSeparator {
                cell.changeSeparator(color: .clear)
            }

            if indexPath.row == 0 {
                cell.cornerTopRadius(radius: 16)
            }
            return cell
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
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        let header: ContentHeaderFooterView<TPHeaderView> = tableView.dequeueReusableHeaderFooter()
        header.innerView.set(text: item.title)
        header.innerView.button.setTitle(item.buttonTitle, for: .normal)
        header.innerView.rightButtonAction = { }
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
        return footer
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        interactor?.didSelectItem(at: indexPath)
    }
}

extension TransfersViewController: TransfersViewInput {
    
    func reload() {
        tableView.reloadData()
    }
}
