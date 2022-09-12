//
//  TPFavoritesViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

class TPFavoritesViewController: BaseViewController {

    var router: TPFavoritesRouter?
    var interactor: TPFavoritesInteractorInput?

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

    private lazy var rightBarButton: UIBarButtonItem = build {
        $0.title = "Изменить"
        $0.style = .done
        $0.target = self
        $0.action = #selector(changeAction)
        $0.setTitleTextAttributes([.foregroundColor: BaseColor.green500], for: .normal)
    }

    private lazy var tableView: UITableView = build(.init(frame: .zero, style: .grouped)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.01))
        $0.layer.cornerRadius = 16
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }

        $0.register(BaseContainerCell<TPFavoritesEmptyView>.self)
        $0.register(BaseContainerCell<TPFavoritesItemView>.self)

        $0.delegate = self
        $0.dataSource = self
    }

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
        title = "Избранное"
        view.backgroundColor = BaseColor.base100
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = rightBarButton

        view.addSubviews(segmentedControl, tableView)

        var layoutConstraints = [NSLayoutConstraint]()

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32)
        ]

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc private func changeAction() {
        if tableView.isEditing {
            tableView.isEditing = false
            rightBarButton.title = "Изменить"
        } else {
            tableView.isEditing = true
            rightBarButton.title = "Готово"
        }
    }

    @objc private func segmentedControlAction() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        interactor?.didSelectSegment(at: segmentedControl.selectedSegmentIndex)
    }
}

extension TPFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        case .history:
            let cell: BaseContainerCell<TPFavoritesItemView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.subtitle
            cell.innerView.iconView.image = item.image
            cell.innerView.dotsView.setImage(item.accessory, for: .normal)
            cell.innerView.dotsView.actionClick = ActionClick(block: { [weak self] sender in
                self?.interactor?.showAlert(indexPath: indexPath)
            })
            return cell
        case .favoritesEmpty:
            let cell: BaseContainerCell<TPFavoritesEmptyView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.imageView.image = item.image
            cell.innerView.titleLabel.text = item.title
            cell.innerView.layer.cornerRadius = 16
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        interactor?.didSelectItem(at: indexPath)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        interactor?.swap(moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}

extension TPFavoritesViewController: TPFavoritesViewInput {

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
