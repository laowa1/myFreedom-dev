//
//  BottomSheetCellProtocol.swift
//  MobileBanking-KassanovaBank
//
//  Created by bnazhdev on 29.09.2021.
//

import UIKit

protocol IPickerInput: UIViewController {
    var presenter: IBottomSheetPresenter? { get }
    func closePicker()
    func updateData()
}

// table
protocol BottomSheetPickerCellProtocol: UITableViewCell {

    associatedtype Item: BottomSheetPickerItemProtocol
    static var estimatedRowHeight: CGFloat { get }
    func configure(viewModel: Item)
}

protocol BottomSheetPickerItemProtocol {
    var title: String { get }
    var description: String? { get }
}

protocol BottomSheetPickerViewDelegate: AnyObject {
    func didSelect(index: Int, id: UUID)
}

// collection
protocol CollectionPickerCellProtocol: UICollectionViewCell {

    associatedtype Item: BottomSheetPickerItemProtocol
    static var itemSize: CGSize { get }
    func configure(viewModel: Item)
}
