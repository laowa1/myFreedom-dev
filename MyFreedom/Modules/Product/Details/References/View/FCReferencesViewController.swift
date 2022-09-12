//
//  FCReferencesViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.06.2022.
//

import UIKit

class FCReferencesViewController: BaseViewController {

    var router: FCReferencesRouterInput?
    var interactor: FCReferencesInteractorInput?

    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    
    private lazy var footerView: ButtonFooterView = build(.init(frame: CGRect(x: 0, y: 0, width: UIView.screenWidth, height: 74))) {
        $0.button.setTitle("Скачать справку", for: .normal)
    }

    private lazy var tableView: UITableView = build(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableHeaderView = nil
        $0.allowsMultipleSelection = true
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

        $0.register(FCReferenceTypeCell.self)
        $0.register(WrapperAccessoryCell<FCReferencePeriodView>.self)
        $0.register(WrapperAccessoryCell<LanguageView>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
        $0.register(BaseContainerCell<PrimaryButtonView<IndexPath>>.self)
        $0.contentInset.bottom = 74
        
//        $0.tableFooterView = footerView
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
        navigationSubtitleLabel.text = "Справки"
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(footerView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: navigationSubtitleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func setActions() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc private func backButtonAction() {
        router?.popViewContoller()
    }
}

extension FCReferencesViewController: FCReferencesViewInput {

    func reloadData() {
        tableView.reloadData()
    }

    func update(at indexPath: IndexPath, selected: Bool) {
        UIView.setAnimationsEnabled(false)
        tableView.reloadRows(at: [indexPath], with: .none)
        UIView.setAnimationsEnabled(true)
        if selected {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func routeToCalendarPage(minDate: Date, selectableDaysCount: Int) {
        router?.routeToCalendarPage(minDate: minDate, selectableDaysCount: selectableDaysCount)
    }
}

extension FCReferencesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.getSectionCount() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getItemCountIn(section: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.getItemBy(indexPath: indexPath) else {
            return UITableViewCell()
        }

        switch item.filedType {
        case .reference:
            let cell: FCReferenceTypeCell =  tableView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel: item)
            return cell
        case .language:
            let cell: WrapperAccessoryCell<LanguageView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.changeSeparator(color: .clear)
            return cell
        case .period:
            let cell: WrapperAccessoryCell<FCReferencePeriodView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(viewModel: item)
            cell.changeSeparator(color: .clear)
            return cell
        case .selectPeriod:
            let cell: WrapperAccessoryCell<FCReferencePeriodView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(viewModel: item)
            cell.changeSeparator(color: .clear)
            if item.subtitle == nil {
                cell.accessoryImageView.image = BaseImage.chevronRight.uiImage
                cell.accessoryImageView.isHidden = false
                cell.innerView.titleLabel.textColor = BaseColor.base800
            } else {
                cell.accessoryImageView.image = BaseImage.mark.uiImage
                cell.innerView.titleLabel.textColor = BaseColor.green500
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }

        switch item.id {
        case .language, .period:
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
        case .language, .period:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedRows = tableView.indexPathsForSelectedRows,
           let selecteIndex = selectedRows.first(where: { $0.section == indexPath.section }) {
            tableView.deselectRow(at: selecteIndex, animated: false)
        }
        
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.didSelectItem(at: indexPath)
    }
}

extension FCReferencesViewController: PrimaryButtonViewDelegate {

    func didSelectButton() {    
    }
}
