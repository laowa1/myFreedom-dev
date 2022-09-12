//
//  JCChooseChildViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 04.07.2022.
//

import UIKit

protocol SingleSelectionViewInput: BaseViewControllerProtocol {
    func routeToBack()
    func routeToPervious()
    func routeToNext()
    func reload()
}

class SingleSelectionViewController<ID: Equatable>: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var interactor: SingleSelectionInteractorInput?
    var router: SingleSelectionRouterInput?
    var id: ID?
    
    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))

    private let tableView: UITableView = build(UITableView(frame: .zero, style: .plain)) {
        $0.backgroundColor = BaseColor.base100
        $0.tableHeaderView = nil
        $0.tableFooterView = UIView()
        $0.keyboardDismissMode = .onDrag
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }

        $0.register(SingleSelectionCell.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
    }

    private lazy var currentLevelView = InputLevelView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        addSubviews()
        setupLayout()
        addActions()

        interactor?.createElements()
    }

    private func configureSubviews() {
        navigationItem.leftBarButtonItem = goBackButton
        goBackButton.tintColor = BaseColor.base900
        view.backgroundColor = BaseColor.base100
        navigationSubtitleLabel.text = "Выберите ребенка"

        guard let levelConfig = interactor?.getCurrentLevelConfig() else { return }
        currentLevelView.configure(currentLevel: levelConfig.currentLevel, maxLevel: levelConfig.maxLevel, delegate: self)
    }

    private func addSubviews() {
        view.addSubviews(tableView, currentLevelView)
    }

    private func setupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += tableView.getLayoutConstraints(over: view, safe: true)

        currentLevelView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            currentLevelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentLevelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currentLevelView.heightAnchor.constraint(equalToConstant: 68),
            currentLevelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func addActions() {
        tableView.delegate = self
        tableView.dataSource = self

    }

    @objc private func backButtonAction() {
       routeToBack()
    }

// MARK: TebleView delegate, dataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getCountBySection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.getElementBy(id: indexPath) else {
            return UITableViewCell()
        }

        let cell: SingleSelectionCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(viewModel: item)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)

        if indexPath.row == 0 {
            cell.roundTopCorners(radius: 16)
        }

        if (indexPath.row == ((interactor?.getCountBySection() ?? 0) - 1)) {
            cell.roundBottomCorners(radius: 16)
            cell.separatorInset =  UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.didSelectItem(at: indexPath, for: UUID())
    }
}

extension SingleSelectionViewController: SingleSelectionViewInput {

    func routeToBack() {
        router?.routeToBack()
    }

    func routeToNext() {
        router?.routeToNext()
    }

    func routeToPervious() {
        router?.routeToPervious()
    }

    func reload() {
        tableView.reloadData()
    }
}

extension SingleSelectionViewController: InputLevelDelegate {

    func onBackButtonClicked() {
        routeToPervious()
    }

    func onNextButtonClicked() {
        interactor?.nextModule()
    }
}

