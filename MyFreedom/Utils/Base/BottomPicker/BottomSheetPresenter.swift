//
//  BottomSheetPresenter.swift
//  MobileBanking-KassanovaBank
//
//  Created by bnazhdev on 19.10.2021.
//

import UIKit

protocol IBottomSheetPresenter: AnyObject {
    func getTitle() -> String
    func getItemBy(index: Int) -> BottomSheetPickerItemProtocol?
    func numberOfItemsInSection() -> Int
    func didSelect(index: Int)
    func getSelectedIndex() -> Int
    func displayCloseButton() -> Bool
    func headerInSectionHeight() -> CGFloat
}

final class BottomSheetPresenter: IBottomSheetPresenter {
    
    private weak var view: IPickerInput?
    private weak var delegate: BottomSheetPickerViewDelegate?
    private var id: UUID?
    private var title: String?
    private var items: [BottomSheetPickerItemProtocol] = []
    private var selectedIndex: Int = 0
    private var hideCloseButton: Bool
    
    init(view: IPickerInput,
         viewModel: BottomSheetPickerViewModel) {
        self.view = view
        self.delegate = viewModel.delegate
        self.id = viewModel.id
        self.title = viewModel.title
        self.items = viewModel.items
        self.hideCloseButton = viewModel.hideCloseButton
        self.selectedIndex = viewModel.selectedIndex
    }
    
    func getTitle() -> String {
        return title ?? ""
    }
    
    func getItemBy(index: Int) -> BottomSheetPickerItemProtocol? {
        return items[safe: index]
    }
    
    func numberOfItemsInSection() -> Int {
        return items.count
    }
    
    func didSelect(index: Int) {
        guard let id = id else { return }
        delegate?.didSelect(index: index, id: id)
        view?.closePicker()
    }
    
    func getSelectedIndex() -> Int {
        return selectedIndex
    }
    
    func headerInSectionHeight() -> CGFloat {
        return getTitle().isEmpty == true ? 8 : 16 + 28 + 16
    }
    
    func displayCloseButton() -> Bool {
        return hideCloseButton
    }
}
