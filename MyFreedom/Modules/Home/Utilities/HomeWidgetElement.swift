//
//  HomeWidgetElement.swift
//  MyFreedom
//
//  Created by &&TairoV on 03.06.2022.
//

import UIKit

struct ExpenseModel: Equatable {
    let partition: CGFloat
    let color: UIColor
}

enum WidgetItemType: Equatable {
    case credit(buttonTitle: String?),
         expense([ExpenseModel]),
         stocks(stockCount: String?, stockStatus: String?, sctockShortTitle: String?)
}

enum ExpenseType: Equatable {
    case payment(sum: Double),
         transfers(sum: Double),
         entertainments(sum: Double),
         products(sum: Double),
         stocks(sum: Double)
}

struct WidgetViewModel: Equatable {
    var title: String?
    var subtitle: String?
    var icon: UIImage?
    var amount: String?
    var type: WidgetItemType
}
