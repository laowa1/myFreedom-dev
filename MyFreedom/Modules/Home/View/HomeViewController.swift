//
//  HomeViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//

import UIKit.UIViewController

class HomeViewController: BaseViewController {

    var router: HomeRouter?
    var interactor: HomeInteractorInput?
    
    private var currentItemFrame: CGRect?
    private lazy var navigationView: CustomNavigation = build {
        $0.backgroundColor = .clear
        $0.leftButtonIcon = BaseImage.stroke
        $0.leftButtonTitle = "Sanzhbek"
        $0.leftButton.titleLabel?.font = BaseFont.bold.withSize(28)
        $0.leftButton.setTitleColor(BaseColor.base900, for: .normal)
        $0.leftButton.imageEdgeInsets.left = 8
        $0.leftButton.semanticContentAttribute = .forceRightToLeft
        
        $0.rightButtonIcon = BaseImage.bonus
        $0.rightButtonTitle = "0,00"
        $0.rightButton.titleLabel?.font = BaseFont.medium.withSize(13)
        $0.rightButton.setTitleColor(BaseColor.base800, for: .normal)
        $0.rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        $0.rightButton.backgroundColor = BaseColor.base50
        $0.rightButton.layer.cornerRadius = 12
        $0.leftButtonAction = { [weak self] in
            self?.router?.routeToProfile(animated: true)
        }
    }
    private let tableView: UITableView = build(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.01))
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false

        $0.register(BaseContainerCell<PrimaryButtonView<IndexPath>>.self)
        $0.register(BaseContainerCell<HomeWidgetsCollectionView>.self)
        $0.register(BaseContainerCell<HomeStoriesCollectionView>.self)
        $0.register(BaseContainerCell<OffersView>.self)
        $0.register(WrapperCell<CardProductView>.self)
        $0.register(WrapperCell<DCAProductView>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<ProductListAddFooterView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)

        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        view.backgroundColor = BaseColor.base100
        addSubviews()
        setupLayout()
        addActions()

        interactor?.createElements()
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(navigationView)
    }

    private func setupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        navigationView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationView.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func addActions() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func nameButtonAction() {
        router?.routeToProfile(animated: true)
    }
}

extension HomeViewController:  BaseTabBarPresentable {

    var baseTabBarItem: BaseTabBarItem {
        let tabBarItem = BaseTabBarItem()
        title = "Главная"
        tabBarItem.title = title
        tabBarItem.icon = BaseImage.home.uiImage
        return tabBarItem
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        case let .story(items, isLoading):
            let cell: BaseContainerCell<HomeStoriesCollectionView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(with: items)
            cell.innerView.delegate = self
            cell.innerView.isLoading = isLoading
            return cell
        case .widgets(let items):
            let cell: BaseContainerCell<HomeWidgetsCollectionView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(items: items)
            return cell
        case .card:
            let cell: WrapperCell<CardProductView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(model: item)
            return cell
        case .deposit, .credit, .account:
            let cell: WrapperCell<DCAProductView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(model: item)
            if !item.showSeparator {
                cell.changeSeparator(color: .clear)
            }
            return cell
        case .offers(let items):
            let cell: BaseContainerCell<OffersView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(items: items)
            return cell
        case .button:
            let cell: BaseContainerCell<PrimaryButtonView<IndexPath>> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.button.backgroundColor = BaseColor.green500
            cell.innerView.button.setTitle(item.title, for: .normal)
            cell.innerView.delegate = self
            cell.innerView.button.layer.cornerRadius = 16
            cell.removeLine()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.title?.isEmpty == false else { return nil }
        switch item.id {
        case .cards, .accounts, .deposits, .credits:
            let header: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
            header.innerView.set(text: item.title)
            header.innerView.button.setImage(BaseImage.expand.uiImage, for: .normal)
            header.innerView.isExpand = item.isExpand
            header.innerView.rightButtonAction = { [weak self] in
                self?.interactor?.expand(section: section)
            }
            return header
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section), item.footer?.isEmpty == false else { return nil }
        switch item.id {
        case .cards, .deposits, .credits:
            let footer: WrapperHeaderFooterView<ProductListAddFooterView> = tableView.dequeueReusableHeaderFooter()
            footer.innerView.set(text: item.footer)
            footer.actionTap = ActionTap(block: { [weak self] _ in
                if section == 3 {
                    self?.routeToDeposit()
                } else if section == 2 {
                    self?.routeToJuniorCardPresentation()
                } else {
                    self?.routeToOpenInvestCard()
                }
            })
            return footer
        case .accounts:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        interactor?.didSelectItem(at: indexPath)
    }
}

extension HomeViewController: HomeViewInput {
        
    func reload() {
        tableView.reloadData()
    }
    
    func routeToCardDetail(type: PDBCardType) {
        router?.routeToCardDetail(type: type)
    }
    
    func routeToAccountDetail() {
        router?.routeToAccountDetail()
    }
    
    func routeToDepositsDetail(type: PDBDepositType) {
        router?.routeToDepositsDetail(type: type)
    }
    
    func presentDocumentList(module: BaseDrawerContentViewControllerProtocol) {
        router?.presentDocumentList(module: module)
    }

    func routeToDeposit() {
        router?.routeToDeposit()
    }

    func routeToOpenInvestCard() {
        router?.routeToOpenInvestCard()
    }

    func routeToJuniorCardPresentation() {
        router?.routeToJuniorCardPresentation()
    }
}

extension HomeViewController: PrimaryButtonViewDelegate {
    func didSelectButton() {
        interactor?.presentOpenCardActions()
    }
}

extension HomeViewController: HomeStoriesViewDelegate {
    
    func didSelectItem(at indexPath: IndexPath, currentItemFrame: CGRect?) {
        self.currentItemFrame = currentItemFrame
        router?.routeToStories()
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension HomeViewController {
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard let currentItemFrame = self.currentItemFrame else { return nil }
        return GrowPresentAnimationController(originFrame: currentItemFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let currentItemFrame = self.currentItemFrame else {
            return nil
        }
        return ShrinkDismissAnimationController(destinationFrame: currentItemFrame)
    }
}
