//
//  JCLBPViewController.swift
//  MyFreedom
//
//  Created by Sanzhar on 06.07.2022.
//

import Foundation
import UIKit

class JCLBPSViewController: BaseViewController {
    
    var router: JCLBPSRouterInput?
    var interactor: JCLBPSInteractorInput?
    
    override var baseModalPresentationStyle: UIModalPresentationStyle { .formSheet }
    
    private let titleLabel: UILabel = build {
        $0.text = "Заблокировать платеж"
        $0.font = BaseFont.medium
        $0.textColor = BaseColor.base900
    }
    private lazy var cancelButton: BaseButton = build {
        $0.backgroundColor = BaseColor.base200
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.setTitle("Отмена", for: .normal)
        $0.titleLabel?.font = BaseFont.medium.withSize(13)
        $0.titleLabel?.textColor = BaseColor.base800
        $0.addTarget(self, action: #selector(onCancelTapped), for: .touchUpInside)
    }
    private let selectAllButtonLabel: UILabel = build {
        $0.text = "Выбрать все"
        $0.font = BaseFont.regular
        $0.textColor = BaseColor.green500
    }
    private lazy var selectAllButton = build(ButtonFactory().getTextButton()) {
        $0.addTarget(self, action: #selector(onSelectAllTapped), for: .touchUpInside)
    }
    private let selectAllImageView = UIImageView(image: BaseImage.checkOff.uiImage)
    private lazy var tableView: UITableView = build {
        $0.delegate = self
        $0.dataSource = self
        $0.allowsMultipleSelection = true
        $0.separatorStyle = .none
        $0.tableHeaderView = nil
        $0.tableFooterView = nil
        $0.rowHeight = 67
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = 0
        $0.showsVerticalScrollIndicator = false
        $0.layer.cornerRadius = 12
        $0.backgroundColor = BaseColor.base100
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }
        
        $0.register(WrapperCell<AccessoryView>.self)
        $0.register(WrapperHeaderFooterView<EmptyHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
    }
    private lazy var blockSelectedPaymentsButton = build(ButtonFactory().getGreenButton()) {
        $0.addTarget(self, action: #selector(onBlockPaymentsTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BaseColor.base100
        view.addSubviews(titleLabel, cancelButton, selectAllButtonLabel, selectAllButton, selectAllImageView,
                         tableView, blockSelectedPaymentsButton)
        setLayoutConstraints()
        
        setBlockPaymentsButton()
    }
    
    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 21),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ]
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            cancelButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16),
            cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalToConstant: 79)
        ]
        
        selectAllButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            selectAllButtonLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            selectAllButtonLabel.heightAnchor.constraint(equalToConstant: 24)
        ]
        
        selectAllImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            selectAllImageView.leftAnchor.constraint(equalTo: selectAllButtonLabel.rightAnchor, constant: 12),
            selectAllImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            selectAllImageView.centerYAnchor.constraint(equalTo: selectAllButtonLabel.centerYAnchor),
            selectAllImageView.heightAnchor.constraint(equalToConstant: 24),
            selectAllImageView.widthAnchor.constraint(equalToConstant: 24)
        ]
        
        selectAllButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            selectAllButton.topAnchor.constraint(equalTo: selectAllButtonLabel.topAnchor),
            selectAllButton.bottomAnchor.constraint(equalTo: selectAllButtonLabel.bottomAnchor),
            selectAllButton.leftAnchor.constraint(equalTo: selectAllButtonLabel.leftAnchor),
            selectAllButton.rightAnchor.constraint(equalTo: selectAllImageView.rightAnchor)
        ]
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: selectAllButton.bottomAnchor, constant: 17),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ]
        
        blockSelectedPaymentsButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            blockSelectedPaymentsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            blockSelectedPaymentsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            blockSelectedPaymentsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            blockSelectedPaymentsButton.heightAnchor.constraint(equalToConstant: 52)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func setBlockPaymentsButton() {
        let isAllPaymentsSelected = interactor?.getSelectedPayments().count == interactor?.getPaymentsList().count
        selectAllImageView.image = isAllPaymentsSelected ? BaseImage.checkOn.uiImage : BaseImage.checkOff.uiImage
        blockSelectedPaymentsButton.setTitle("Заблокировать \(interactor?.getSelectedPayments().count ?? 0)", for: .normal)
        blockSelectedPaymentsButton.isHidden = interactor?.getSelectedPayments().count ?? 0 == 0
    }
    
    @objc private func onCancelTapped() {
        guard let payments = interactor?.getSavedPayments() else { return }
        router?.cancelToBack(payments: payments)
    }
    
    @objc private func onSelectAllTapped() {
        interactor?.toggleAllPaymentsAreSelected()
        setBlockPaymentsButton()
    }
    
    @objc private func onBlockPaymentsTapped() {
        guard let payments = interactor?.getFinishedSelection() else { return }
        router?.routeToBack(payments: payments)
    }
}

extension JCLBPSViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.getPaymentsList().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let payment = interactor?.getPaymentFromList(at: indexPath.row)
        let cell: WrapperCell<AccessoryView> = tableView.dequeueReusableCell(for: indexPath)
        
        cell.innerView.iconView.image = payment?.icon
        cell.innerView.titleLabel.text = payment?.title
        let image = interactor?.paymentIsSelected(at: indexPath.row) ?? false ?  BaseImage.checkOn.uiImage : BaseImage.checkOff.uiImage
        cell.innerView.accessoryView.image = image
        cell.selectionStyleIsEnabled = false
        
        if indexPath.row == 0 {
            cell.cornerTopRadius(radius: 16)
        }
        
        if indexPath.row == (interactor?.getPaymentsList().count ?? 0) - 1 {
            cell.changeSeparator(color: .clear)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
        return footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.selectPayment(at: indexPath.row)
        
        let cell = tableView.cellForRow(at: indexPath) as? WrapperCell<AccessoryView>
        let image = interactor?.paymentIsSelected(at: indexPath.row) ?? false ?  BaseImage.checkOn.uiImage : BaseImage.checkOff.uiImage
        cell?.innerView.accessoryView.image = image
        
        setBlockPaymentsButton()
    }
}

extension JCLBPSViewController: JCLBPSViewInput {
    
    func passPayments() {
        interactor?.passPayments()
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
}
