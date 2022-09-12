//
//  ChangeIconItemCell.swift
//  MyFreedom
//
//  Created by m1pro on 12.06.2022.
//

import UIKit.UICollectionViewCell

class ChangeIconItemCell: CollectionPickerItemCell {
    
    class override var itemSize: CGSize { CGSize(width: (Self.screenWidth-32)/3, height: 126) }
    override var imageSize: CGSize { CGSize(width: 48, height: 48) }
}
