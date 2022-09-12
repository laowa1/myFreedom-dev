//
//  PadItemCellTappable.swift
//  MyFreedom
//
//  Created by m1pro on 09.04.2022.
//

import UIKit

protocol PadItemCellTappable where Self: UICollectionViewCell {

    func setTapState()
    func setNormalState()
}
