//
//  BottomSheetViewController.swift
//  MobileBanking-KassanovaBank
//
//  Created by bnazhdev on 29.09.2021.
//

import UIKit

protocol IBottomSheetPickerInput: IPickerInput, UITableViewDataSource, UITableViewDelegate { }

class BottomSheetPickerViewController<Cell: BottomSheetPickerCellProtocol>: UIViewController, IBottomSheetPickerInput {

    var presenter: IBottomSheetPresenter? {
        didSet {
            updateData()
        }
    }

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = Cell.estimatedRowHeight
//        tableView.rowHeight = Cell.estimatedRowHeight
        tableView.register(Cell.self)
        tableView.register(ContentHeaderFooterView<BackdropHeaderView>.self)
        tableView.backgroundColor = BaseColor.base50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        tableView.bounces = false
        tableView.backgroundColor = .white
        tableView.contentInset.bottom = 0
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += tableView.getLayoutConstraints(over: self.view, safe: false)

        NSLayoutConstraint.activate(layoutConstraints)
        updateData()
    }

    func closePicker() {
        dismissDrawer(completion: nil)
    }

    func updateData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItemsInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        if let viewModel = presenter?.getItemBy(index: indexPath.row) as? Cell.Item {
            cell.configure(viewModel: viewModel)
        }
        if indexPath.row == presenter?.getSelectedIndex() {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        cell.backgroundColor = .white
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        presenter?.didSelect(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = presenter?.getTitle() else { return UIView() }
        let headerView: ContentHeaderFooterView<BackdropHeaderView> = tableView.dequeueReusableHeaderFooter()
        headerView.innerView.configure(title: title) { [weak self] in
            self?.closePicker()
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return presenter?.headerInSectionHeight() ?? 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension BottomSheetPickerViewController: BaseDrawerContentViewControllerProtocol {

    var contentViewHeight: CGFloat { tableView.contentSize.height }
}
