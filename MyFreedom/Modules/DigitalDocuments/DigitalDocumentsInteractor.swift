//
//  DigitalDocumentsInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 18.05.2022.
//

import Foundation

class DigitalDocumentsInteractor {

    private var view: DigitalDocumentsViewInput
    private let title: String?
    private let url: URL

    init(view: DigitalDocumentsViewInput, title: String?, url: URL) {
        self.view = view
        self.title = title
        self.url = url
    }
}

extension DigitalDocumentsInteractor: DigitalDocumentsInteractorInput {
    func loadContent() {
        view.set(title: title, url: url)
    }
}
