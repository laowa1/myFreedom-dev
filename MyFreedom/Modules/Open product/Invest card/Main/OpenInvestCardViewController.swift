//
//  CHCPresentationViewContoller.swift
//  MyFreedom
//
//  Created by &&TairoV on 30.06.2022.
//

import UIKit

protocol OpenInvestCardViewInput: BaseViewControllerProtocol {
    func routeToBack()
    func routeToOpenJuniorCard()
    func routeToOtp(phone: String)
    func routeToLoader()
    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate)
    func popToRootShowInvestCard()
    func reload()
}

class OpenInvestCardViewController: BaseViewController {

    var interactor: OpenInvestCardInteractorInput?
    var router: OpenInvestCardRouterInput?

    private let closeBtton: UIButton = build {
        $0.backgroundColor = .clear
        $0.setImage(BaseImage.roundClose.uiImage, for: .normal)
    }

    private let tableView: UITableView = build(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor = BaseColor.base100
        $0.separatorStyle = .none
        $0.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.01))
        $0.tableFooterView = nil
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }

        $0.register(BaseContainerCell<CleanableImageView>.self)
        $0.register(BaseContainerCell<ButtonTermsView>.self)
        $0.register(WrapperCell<JCInfoView>.self)
        $0.register(WrapperCell<CFConditionsView>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BaseColor.base200
        addSubviews()
        setupLayout()
        addActions()

        interactor?.createElements()
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(closeBtton)
    }

    private func setupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        closeBtton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            closeBtton.heightAnchor.constraint(equalToConstant: 32),
            closeBtton.widthAnchor.constraint(equalToConstant: 32),
            closeBtton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeBtton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
        ]

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += tableView.getLayoutConstraints(over: view, safe: false)

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func addActions() {
        tableView.delegate = self
        tableView.dataSource = self

        closeBtton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    @objc private func closeButtonTapped() {
        router?.routeToBack()
    }
}

extension OpenInvestCardViewController: OpenInvestCardViewInput {

    func routeToBack() {
        router?.routeToBack()
    }

    func routeToOpenJuniorCard() {
        router?.routeToPreviewNewInvest()
    }

    func routeToOtp(phone: String) {
        router?.routeToOtp(phone: phone)
    }

    func routeToInformConfirmIdentity(model: InformPUViewModel, delegate: InformPUButtonDelegate) {
        router?.routeToInformConfirmIdentity(model: model, delegate: delegate)
    }

    func routeToLoader() {
        router?.routeToLoader()
    }

    func popToRootShowInvestCard() {
        router?.popToRootShowInvestCard()
    }

    func reload() {
        tableView.reloadData()
    }
}

extension OpenInvestCardViewController: UITableViewDataSource, UITableViewDelegate {

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
            let cell: BaseContainerCell<CleanableImageView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.imageView.image = item.image
            return cell
        case .features:
            let cell: WrapperCell<JCInfoView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.description
            cell.innerView.imageView.image = item.image
            cell.changeSeparator(color: .clear)
            return cell
        case .rate:
            let cell: WrapperCell<CFConditionsView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = item.title
            cell.innerView.subtitleLabel.text = item.description
            cell.changeSeparator(color: .clear)
            return cell
        case .rateInfo:
            let cell: WrapperCell<CFConditionsView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.titleLabel.text = nil
            cell.innerView.subtitleLabel.font = BaseFont.regular.withSize(13)
            cell.innerView.subtitleLabel.textColor = BaseColor.base700
            cell.innerView.subtitleLabel.text = item.description
            cell.changeSeparator(color: .clear)
            return cell
        case .button:
            let cell: BaseContainerCell<ButtonTermsView> = tableView.dequeueReusableCell(for: indexPath)
            cell.innerView.actionButton.setTitle(item.title, for: .normal)
            cell.innerView.termsLabel.attributedText = interactor?.getTermsString()
            cell.innerView.buttonTapped = { [weak self] in
                self?.routeToOpenJuniorCard()
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section) else { return nil }
        switch item.id {
        case .features, .rates:
            let header: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
            header.innerView.set(text: item.title)
            return header
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = interactor?.getSectiontBy(section: section) else { return nil }
        switch item.id {
        case .features, .rates:
            let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
            return footer
        default:
            return nil
        }
    }
}
