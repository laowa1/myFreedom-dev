//
//  DepositAwardsViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 23.06.2022.
//

import UIKit

class DepositRewardsViewController: BaseViewController {

    var interactor: DepositRewardsInteractorInput?
    var router: DepositRewardsRouterInput?

    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))

    private lazy var tableView: UITableView = build(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableHeaderView = nil
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.contentInsetAdjustmentBehavior = .never
        $0.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.01))
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }

        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
        $0.register(BaseContainerCell<DepositRewardsTotalVeiw>.self)
        $0.register(WrapperCell<DepositRewardsDetailView>.self)
    }

    override func viewDidLoad() {
         super.viewDidLoad()

        configureView()
        addSubviews()
        setupLayout()
        addActions()

        interactor?.createElements()
    }

    private func configureView() {
        navigationItem.leftBarButtonItem = goBackButton
        goBackButton.tintColor = BaseColor.base900
        navigationSubtitleLabel.text = "????????????????????????????"
        view.backgroundColor = BaseColor.base100
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func setupLayout() {
        var layoutConstrints = [NSLayoutConstraint]()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += [
            tableView.topAnchor.constraint(equalTo: navigationSubtitleLabel.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstrints)
    }

    private func addActions() {

    }

    @objc private func backButtonAction() {
        router?.routeToBack()
    }
}

extension DepositRewardsViewController: DepositRewardsViewInput {

    func reload() {
        tableView.reloadData()
    }

    func showPeriodSelection(module: BaseDrawerContentViewControllerProtocol) {
        router?.showPeriodSelection(module: module)
    }

    func routeToCalendarPage(minDate: Date, selectableDaysCount: Int) {
        router?.routeToCalendarPage(minDate: minDate, selectableDaysCount: selectableDaysCount)
    }
}

extension DepositRewardsViewController: UITableViewDataSource {

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
        case .total:
            let cell: BaseContainerCell<DepositRewardsTotalVeiw> =  tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.awardsTotalLabel.text = item.totalReward
            cell.innerView.rewardsPrecentage.text = item.precent
            cell.innerView.buttonTapped = { [weak self] in
                self?.interactor?.showPeriodSelolection()
            }
            return cell
        case .period:
            let cell: WrapperCell<DepositRewardsDetailView> =  tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.descriptionLabel.text = item.description
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        switch item.id {
        case .period:
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
        case .period:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }
}

extension DepositRewardsViewController: UITableViewDelegate { }
