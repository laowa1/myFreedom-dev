//
//  FCReferencesViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.06.2022.
//

import Foundation

protocol FCReferencesViewInput: BaseViewController {

    func reloadData()
    func update(at indexPath: IndexPath, selected: Bool)
    func routeToCalendarPage(minDate: Date, selectableDaysCount: Int)
}
