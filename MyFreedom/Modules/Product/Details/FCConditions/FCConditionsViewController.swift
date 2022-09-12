//
//  FCContiotionsViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import UIKit

protocol FCConditionsViewInput: BaseViewControllerProtocol {
   func reloadData()
}

class FCConditionsViewController: BaseViewController {

    var router: FCConditionsRouterInput?
    var interactor: FCConditionsInteractorInput?

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
        $0.contentInsetAdjustmentBehavior = .never
        $0.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.01))
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }

        $0.register(WrapperHeaderFooterView<EmptyHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
        $0.register(WrapperCell<CFConditionsView>.self)
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
        navigationSubtitleLabel.text = "Условия Freedom Card"
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
    }

    @objc private func backButtonAction() {
        router?.routeToBack()
    }
}

extension FCConditionsViewController: FCConditionsViewInput {

    func reloadData() {
        tableView.reloadData()
    }
}

extension FCConditionsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getItemCountIn(section: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.getItemBy(indexPath: indexPath) else {
            return UITableViewCell()
        }

        switch item.fieldType {
        case .condition:
            let cell: WrapperCell<CFConditionsView> = tableView.dequeueReusableCell(for: indexPath)
            cell.changeSeparator(color: .clear)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.subtitle
            return cell
        case .terms:
            let cell: WrapperCell<CFConditionsView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = nil
            cell.innerView.subtitleLabel.font = BaseFont.regular.withSize(13)
            cell.innerView.subtitleLabel.textColor = BaseColor.base700
            cell.innerView.subtitleLabel.text = item.subtitle
            cell.changeSeparator(color: .clear)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: WrapperHeaderFooterView<EmptyHeaderView> = tableView.dequeueReusableHeaderFooter()
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
        return footer
    }
}
