//
//  EPContactsPickerInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 07.07.2022.
//

import Foundation

protocol EPContactsPickerInteractorInput {
    func getCurrentLevelConfig() -> (currentLevel: Int, maxLevel: Int)
    func didSelectItem(at index: IndexPath)
    func nextModule()
}

struct EPContactsPickerViewModel {
    var title: String?
    var delegate: EPPickerDelegate?
    var currentLevel: Int?
    var maxLevel: Int?
    var nextModule: BaseViewControllerProtocol?
    var previousModule: BaseViewControllerProtocol?
}

class EPContactsPickerInteractor {

    private var view: EPContactsPickerViewInput?
    private var viewModel: EPContactsPickerViewModel

    init(view: EPContactsPickerViewInput, viewModel: EPContactsPickerViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
}

extension EPContactsPickerInteractor: EPContactsPickerInteractorInput {

    func didSelectItem(at index: IndexPath) {

        if viewModel.nextModule != nil {
            view?.routeToNext()
        } else {
            view?.routeToBack()
        }
    }

    func getCurrentLevelConfig() -> (currentLevel: Int, maxLevel: Int) {
        (viewModel.currentLevel ?? 0, viewModel.maxLevel ?? 0)
    }

    func nextModule() {
    
    }
}
