//
//  JCLBPLViewController.swift
//  MyFreedom
//
//  Created by Sanzhar on 08.07.2022.
//

import Foundation
import UIKit

class JCLBPLViewController: BaseViewController {
    
    var router: JCLBPLRouterInput?
    var interactor: JCLBPLInteractorInput?
    
    private lazy var tableView = build(UITableView()) {
        $0.backgroundColor = BaseColor.base100
        $0.separatorStyle = .none
        $0.rowHeight = 67
        $0.sectionHeaderHeight = 23
        
        $0.delegate = self
        $0.dataSource = self
        
        $0.register(WrapperCell<AccessoryView>.self)
        $0.register(WrapperCell<CFConditionsView>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BaseColor.base100
        view?.addSubviews(tableView)
        tableView.layout(over: view)
        
        editButtonItem.tintColor = BaseColor.green500
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        interactor?.focusEditing(editing)
        toggleEditItem()
    }
    
    private func toggleEditItem() {
        if let paymentsCount = interactor?.getBlockedPayments().count {
            if paymentsCount > 0 || (paymentsCount == 0 && (interactor?.isFocusEditing() ?? false)) {
                navigationItem.rightBarButtonItem = editButtonItem
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    @objc private func blockPaymentsGesture() {
        router?.routeToBlockedPaymentSelection(payments: interactor?.getBlockedPayments())
    }
}

extension JCLBPLViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sectionsCount = interactor?.getSectionCount() {
            toggleEditItem()
            return sectionsCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = interactor?.getSection(at: section) else { return 0 }
        
        switch section {
        case .blockedPayments:
            return interactor?.getBlockedPayments().count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = interactor?.getSection(at: indexPath.section) else { return UITableViewCell() }
        
        let cell: UITableViewCell
        
        switch section {
        case .addBlockedPayments:
            let addCell: WrapperCell<AccessoryView> = tableView.dequeueReusableCell(for: indexPath)
            
            addCell.innerView.iconView.image = BaseImage.pdBlockedCard.uiImage
            addCell.innerView.titleLabel.text = "Заблокировать платеж"
            addCell.innerView.titleLabel.textColor = BaseColor.green500
            addCell.innerView.accessoryView.image = BaseImage.chevronRight.uiImage
            addCell.innerView.layer.cornerRadius = 12
            addCell.innerView.backgroundColor = BaseColor.base50
            addCell.changeSeparator(color: .clear)
            addCell.innerView.clipsToBounds = true
            
            addCell.cornerRadius(radius: 12)
            
            cell = addCell
        case .info:
            let infoCell: WrapperCell<CFConditionsView> = tableView.dequeueReusableCell(for: indexPath)
            
            infoCell.innerView.subtitleLabel.text = "Заблокированные платежи будут недоступны вашему ребенку в приложении"
            infoCell.innerView.subtitleLabel.font = BaseFont.regular.withSize(14)
            infoCell.innerView.subtitleLabel.textColor = BaseColor.base700
            infoCell.innerView.subtitleLabel.textAlignment = .center
            infoCell.innerView.backgroundColor = BaseColor.base100
            infoCell.setWrapperViewBackground(color: BaseColor.base100)
            infoCell.changeSeparator(color: .clear)
            
            cell = infoCell
        case .blockedPayments:
            guard let payment = interactor?.getBlockedPaymet(at: indexPath.row),
                  let isEditing = interactor?.isFocusEditing()
            else { return UITableViewCell() }
            
            let blockedCell: WrapperCell<AccessoryView> = tableView.dequeueReusableCell(for: indexPath)
            
            blockedCell.innerView.iconView.image = payment.icon
            blockedCell.innerView.titleLabel.text = payment.title
            blockedCell.innerView.accessoryView.image = isEditing ? BaseImage.deleteRow.uiImage : nil
            blockedCell.innerView.layer.cornerRadius = 12
            blockedCell.innerView.backgroundColor = BaseColor.base50
            
            if indexPath.row == (interactor?.getBlockedPayments().count ?? 0) - 1 {
                blockedCell.changeSeparator(color: .clear)
                blockedCell.cornerBottomRadius(radius: 12)
            }
            
            cell = blockedCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let section = interactor?.getSection(at: section),
           section == .blockedPayments {
            if let blockedPayments = interactor?.getBlockedPayments(),
               blockedPayments.count > 0 {
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = interactor?.getSection(at: section) else { return nil }
        
        switch section {
        case .blockedPayments:
            if let paymentCount = interactor?.getBlockedPayments().count,
               paymentCount > 0 {
                let header: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
                header.cornerRadius = 12
                header.innerView.set(text: "Заблокированные \(paymentCount)")
                return header
            }
            return nil
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = interactor?.getSection(at: indexPath.section) else { return }
        
        switch section {
        case .addBlockedPayments:
            router?.routeToBlockedPaymentSelection(payments: interactor?.getBlockedPayments())
        case .info:
            break
        case .blockedPayments:
            guard let isEditing = interactor?.isFocusEditing() else { return }
            
            if isEditing {
                interactor?.deletePayment(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
}

extension JCLBPLViewController: JCLBPLViewInput {
    
    func passPayments(_ payments: [JCLPayments]) {
        interactor?.passPayments(payments)
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
}
