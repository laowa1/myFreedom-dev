//
//  JCChooseChildInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 04.07.2022.
//

import UIKit

protocol SingleSelectionDelegate {
    func didSelect<ID>(at indexPath: IndexPath, for id: ID)
}

protocol SingleSelectionInteractorInput {
    func getCountBySection() -> Int
    func getElementBy(id: IndexPath) -> SingleSelectionItem
    func didSelectItem(at indexPath: IndexPath, for id: UUID)
    func getCurrentLevelConfig() -> (currentLevel: Int, maxLevel: Int)
    func nextModule()
    func createElements()
}

struct SingleSelectionViewModel {
    var title: String?
    var currentLevel: Int?
    var maxLevel: Int?
    var elements: [SingleSelectionItem]
    var delegate: SingleSelectionDelegate?
    var nextModule: BaseViewControllerProtocol?
    var previousModule: BaseViewControllerProtocol?
}

struct SingleSelectionItem {
    let title: String
    var description: String? = nil
    var isSelected: Bool = false
    var accessoryImage: UIImage? = BaseImage.selection.uiImage
}

class SingleSelectionInteractor {

    private var view: SingleSelectionViewInput?
    private var viewModel: SingleSelectionViewModel
    private var delegate: SingleSelectionDelegate?
    private var selectedItem: SingleSelectionItem?
    private var id: UUID?

    init(view: SingleSelectionViewInput, viewModel: SingleSelectionViewModel) {
        self.view = view
        self.viewModel = viewModel
        self.delegate = viewModel.delegate
    }
}

extension SingleSelectionInteractor: SingleSelectionInteractorInput {

    func getElementBy(id: IndexPath) -> SingleSelectionItem {
        viewModel.elements[id.row]
    }

    func  getCountBySection() -> Int {
        viewModel.elements.count
    }

    func createElements() {
        view?.reload()
    }

    func didSelectItem(at indexPath: IndexPath, for id: UUID) {
        selectedItem = getElementBy(id: indexPath)
        delegate?.didSelect(at: indexPath, for: id)
    }

    func getCurrentLevelConfig() -> (currentLevel: Int, maxLevel: Int) {
        (viewModel.currentLevel ?? 0, viewModel.maxLevel ?? 0)
    }

    func nextModule() {
        if (selectedItem != nil) {
            view?.routeToNext()
        }
    }
}
