//
//  IncomeCardViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 23.06.2022.
//

import UIKit

class IncomeCardViewController: BaseViewController {

    var interactor: IncomeCardInteractorInput?
    var router: IncomeCardRouterInput?

    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))

    private lazy var subtitleLabel: PaddingLabel = build {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.regular.withSize(16)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "Ежедневное начисление 3% годовых"
    }

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
        $0.register(WrapperCell<IncomeCardDetailView>.self)
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
        navigationSubtitleLabel.text = "Доходы"
        view.backgroundColor = BaseColor.base100
    }

    private func addSubviews() {
        view.addSubviews(subtitleLabel, tableView)
    }

    private func setupLayout() {
        var layoutConstrints = [NSLayoutConstraint]()

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += [
            subtitleLabel.topAnchor.constraint(equalTo: navigationSubtitleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += [
            tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
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

extension IncomeCardViewController: IncomeCardViewInput {

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

extension IncomeCardViewController: UITableViewDataSource {

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
            let cell: WrapperCell<IncomeCardDetailView> =  tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.descriptionLabel.text = item.description
            if !item.showSeparator {
                cell.changeSeparator(color: .clear)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section) else { return nil }
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
        guard let item = interactor?.getSectiontBy(section: section) else { return nil }
        switch item.id {
        case .period:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }
}

extension IncomeCardViewController: UITableViewDelegate { }
