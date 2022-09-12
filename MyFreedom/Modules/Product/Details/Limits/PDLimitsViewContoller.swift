//
//  PDLimitsViewContoller.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import UIKit

class PDLimitsViewContoller: BaseViewController {
    
    var router: PDLimitsRouterInput?
    var interactor: PDLimitsInteractor?
    
    private var currentItemFrame: CGRect?
    private let refreshControl = UIRefreshControl()
    
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
        
        $0.register(BaseContainerCell<PDLimitsDisableView>.self)
        $0.register(BaseContainerCell<PDLimitsItemView>.self)
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
        navigationSubtitleLabel.text = "Лимиты"
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
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func backButtonAction() {
        router?.popViewContoller()
    }
    
    @objc func refreshData() {
        update(at: IndexPath(item: 0, section: 0))
        refreshControl.endRefreshing()
    }
}

extension PDLimitsViewContoller: PDLimitsViewInput {

    func reloadData() {
        tableView.reloadData()
    }

    func update(at indexPath: IndexPath) {
        UIView.setAnimationsEnabled(false)
        tableView.reloadRows(at: [indexPath], with: .none)
        UIView.setAnimationsEnabled(true)
    }

    func presentBottomSheet(module: BaseDrawerContentViewControllerProtocol) {
        router?.presentBottomSheet(module: module)
    }
}

extension PDLimitsViewContoller: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getItemsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = interactor?.getItemsElementBy(id: indexPath) else {
            return UITableViewCell()
        }
        
        if viewModel.isActive {
            let cell: BaseContainerCell<PDLimitsItemView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(viewModel: viewModel)
            cell.innerView.titleButton.actionClick = ActionClick(block: { [weak self] _ in
                self?.interactor?.presentInfoBS()
            })
            return cell
        } else {
            let cell: BaseContainerCell<PDLimitsDisableView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(viewModel: viewModel)
            cell.innerView.toogleButton.actionClick = ActionClick(block: { [weak self] _ in
                self?.interactor?.showAlert(index: indexPath)
            })
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//        interactor?.didSelectItem(at: indexPath)
        router?.presentDetail()
    }
}
