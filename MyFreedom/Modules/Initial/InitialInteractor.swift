//
//  InitialInteractor.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 11.03.2022.
//

import UIKit

protocol InitialInteractorInput: AnyObject {
    func performTasks()
}

class InitialInteractor {

    private unowned let view: InitialViewInput
    private let jailbreakDetectionService: JailbreakDetectionService

    init(
        view: InitialViewInput,
        jailbreakDetectionService: JailbreakDetectionService
    ) {
        self.view = view
        self.jailbreakDetectionService = jailbreakDetectionService
    }

    private func fetchInitialData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.passData()
        }
    }
}

extension InitialInteractor: InitialInteractorInput {

    func performTasks() {
        guard !jailbreakDetectionService.isJailbrokenDevice else {
            let message = "Ваше устройство взломано\n Пользоваться данным приложением запрещено"
            view.show(warning: message)
            return
        }

        fetchInitialData()
    }
}
