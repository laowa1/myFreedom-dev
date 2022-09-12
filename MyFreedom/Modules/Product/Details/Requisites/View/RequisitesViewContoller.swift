//
//  CardRequisitesViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 09.06.2022.
//

import UIKit

class RequisitesViewController: BaseViewController {

    var router: RequisitesRouterInput?
    var interactor: RequisitesInteractorInput?

    override var baseModalPresentationStyle: UIModalPresentationStyle { .formSheet }

    private var headerView = BackdropHeaderView()
    private lazy var tableView: UITableView = build(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableHeaderView = nil
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.contentInset.bottom = 90
        
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
        $0.register(WrapperCell<CardRequisiteView>.self)
        $0.register(BaseContainerCell<FreedomCardView>.self)

        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }
    }

    private let shareButton: UIButton = build {
        $0.setTitle("Поделиться", for: .normal)
        $0.setImage(BaseImage.share.uiImage, for: .normal)
        $0.titleLabel?.font = BaseFont.semibold.withSize(16)
        $0.setTitleColor(BaseColor.base800, for: .normal)
        $0.layer.cornerRadius = 16
        $0.backgroundColor = BaseColor.base200
    }

    override func viewDidLoad() {
        addSubviews()
        setupLayout()
        addActions()

        view.backgroundColor = BaseColor.base100
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(shareButton)
    }

    private func setupLayout() {
        var layoutConstrints = [NSLayoutConstraint]()

        headerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += [
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        shareButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += [
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareButton.heightAnchor.constraint(equalToConstant: 52),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ]

        NSLayoutConstraint.activate(layoutConstrints)
    }

    private func addActions() {
        tableView.delegate = self
        tableView.dataSource = self

        headerView.configure(title: "Реквезиты", handleClose: {[weak self] in
            self?.dismiss(animated: true, completion: nil)
        })

        shareButton.addTarget(self, action: #selector(shareRequisites), for: .touchUpInside)
    }

    @objc private func shareRequisites() {
        router?.routeShare(text: "Реквезиттары")
    }
}

extension RequisitesViewController: RequisitesViewInput {

    func reload() {
        tableView.reloadData()
    }
}

extension RequisitesViewController: UITableViewDataSource {

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
        case .card:
            let cell: BaseContainerCell<FreedomCardView> =  tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.actionButtonPressed = { [weak self] type in
                self?.interactor?.writeItemToClipboard(type: type)
            }
            return cell
        case .requisites:
            let cell: WrapperCell<CardRequisiteView> =  tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.set(title: item.title, subtitle: item.description, icon: item.icon)
            cell.innerView.accessoryPressed = { [weak self] type in
                self?.interactor?.writeItemToClipboard(type: type)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        switch item.id {
        case .requisites:
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
        case .requisites:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }
}

extension RequisitesViewController: UITableViewDelegate {

}
