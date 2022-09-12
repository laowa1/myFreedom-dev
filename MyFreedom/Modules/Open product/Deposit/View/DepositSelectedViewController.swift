//
//  DepositSelectedViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

class DepositSelectedViewController: BaseViewController {

    var router: DepositSelectedRouter?
    var interactor: DepositSelectedInteractorInput?

    enum TextFieldId: Int {
        case iWantToInvest = 0, iWillReplenishItMonthly
    }

    private let topCoverView = UIView()
    private let contentView = UIView()

    private lazy var segmentedControl: UISegmentedControl = build {
        let selectedSegmentAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: BaseColor.base900,
            .font: BaseFont.medium.withSize(14)
        ]
        let normalSegmentAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: BaseColor.base900,
            .font: BaseFont.medium.withSize(14)
        ]

        $0.selectedSegmentTintColor = BaseColor.base50
        $0.backgroundColor = BaseColor.base200
        $0.setTitleTextAttributes(selectedSegmentAttributes, for: .selected)
        $0.setTitleTextAttributes(normalSegmentAttributes, for: .normal)
        $0.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
    }

    private lazy var tableView: UITableView = build(.init(frame: .zero, style: .grouped)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableFooterView = tableFooterView
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = 0
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.01))
        $0.layer.cornerRadius = 16
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }

        $0.register(BaseContainerCell<DepositSelectedItemView>.self)
        $0.register(WrapperCell<SelectionListView>.self)
        $0.register(WrapperCell<TPTitleTextFieldView<TextFieldId>>.self)

        $0.delegate = self
        $0.dataSource = self
    }

    private lazy var calculateButton: BaseButton = build(ButtonFactory().getGreenButton()) {
        $0.setTitle("Посчитать", for: .normal)
    }

    private lazy var tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: viewSize?.width ?? 0, height: 116))

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()

        interactor?.generateInital()
    }

    override func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        navigationController.setNavigationBarHidden(false, animated: false)
    }

    private func configureSubviews() {
        title = "Открыть депозит"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = BaseColor.base100

        view.addSubviews(topCoverView, segmentedControl, contentView, tableView)
        tableFooterView.addSubview(calculateButton)

        var layoutConstraints = [NSLayoutConstraint]()

        topCoverView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            topCoverView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topCoverView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topCoverView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += segmentedControl.getLayoutConstraints(over: topCoverView, margin: 16)
        layoutConstraints += [segmentedControl.heightAnchor.constraint(equalToConstant: 32)]

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += calculateButton.getLayoutConstraints(
            over: tableFooterView,
            left: 16,
            top: 40,
            right: 16,
            bottom: 24
        )

        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc private func segmentedControlAction() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        interactor?.didSelectSegment(at: segmentedControl.selectedSegmentIndex)
    }
}

extension DepositSelectedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.getSectionsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getCountBy(section: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.getElementBy(indexPath: indexPath) else {
            return UITableViewCell()
        }

        switch item.fieldType {
        case .depositInfo(let items):
            let cell: BaseContainerCell<DepositSelectedItemView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.subtitle
            cell.innerView.configure(items: items)
            cell.innerView.layer.cornerRadius = 16
            return cell
        case .depositType(let items):
            let cell: WrapperCell<SelectionListView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.set(items: items)
            cell.changeSeparator(color: .clear)
            if indexPath.row == 0 {
                cell.cornerTopRadius(radius: 16)
            }
            return cell
        case .input(let id):
            let cell: WrapperCell<TPTitleTextFieldView<TextFieldId>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.title = item.title
            cell.innerView.textField.font = BaseFont.regular.withSize(16)
            cell.innerView.placeholder = item.subtitle ?? ""
            cell.innerView.textField.text = item.value
            cell.innerView.delegate = self
            cell.innerView.id = id
            cell.innerView.isEditable = false
            cell.changeSeparator(color: .clear)
            if id == .iWillReplenishItMonthly {
                cell.cornerBottomRadius(radius: 16)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        interactor?.didSelectItem(at: indexPath)
    }
}

extension DepositSelectedViewController: DepositSelectedViewInput {

    func pass(segmentTitles: [String]) {
        guard !segmentTitles.isEmpty else {
            segmentedControl.removeFromSuperview()
            return
        }

        segmentTitles.enumerated().forEach {
            segmentedControl.insertSegment(withTitle: $0.element, at: $0.offset, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }

    func deleteItemElement(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .none)
        tableView.reloadInputViews()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
    }
    
    func reload() {
        tableView.reloadData()
    }
}

extension DepositSelectedViewController: TPTextFieldViewDelegate {

    func didSelectView<ID>(at id: ID) {
//        guard let selectedID = id as? TextFieldId else { return }
//        interactor?.didSelectItem(at: selectedID.rawValue)
    }

    func didPressAuxilaryButton<ID>(forId id: ID) {
//        guard let fieldId = id as? TextFieldId else { return }
//        switch fieldId {
//        case .phoneNumber:
//            interactor?.didSelectChooseContact()
//        default: return
//        }
    }

    func didBeginEditing<ID>(text: String, forId id: ID) {
//        guard let fieldId = id as? TextFieldId else { return }
//        switch fieldId {
//        case .name:
//            print("Witched name")
//        default: return
//        }
    }
}
