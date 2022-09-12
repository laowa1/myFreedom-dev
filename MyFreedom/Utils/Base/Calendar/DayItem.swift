//
//  DayItem.swift
//  MyFreedom
//
//  Created by m1pro on 16.06.2022.
//

struct DayItem {
    let day: Int
    let isEnabled: Bool
}

struct CalendarHeaderItem {

    let title: String
    let year: Int
    let month: Int
    var dayItems: [DayItem]
}
