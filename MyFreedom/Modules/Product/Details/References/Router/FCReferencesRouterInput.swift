//
//  FCReferencesRouterInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.06.2022.
//

import Foundation

protocol FCReferencesRouterInput {
    
    func popViewContoller()
    func routeToCalendarPage(minDate: Date, selectableDaysCount: Int)
}
