//
//  CollectionPickerItemCell.swift
//  MyFreedom
//
//  Created by m1pro on 11.06.2022.
//

import UIKit.UICollectionViewCell

struct CollectionPickerPickerItem: BottomSheetPickerItemProtocol {
    let title: String
    var description: String? = nil
    var image: BaseImage?
    var isSelected: Bool = false
}

class CollectionPickerItemCell: UICollectionViewCell, CollectionPickerCellProtocol {

    class var itemSize: CGSize { CGSize(width: (Self.screenWidth-32)/3, height: 208) }
    
    var imageSize: CGSize { CGSize(width: 60, height: 130) }

    private let itemIcon: UIImageView = build {
        $0.contentMode = .scaleToFill
    }

    private var itemTitle: UILabel = build {
        $0.textColor = BaseColor.base900
        $0.font = BaseFont.regular.withSize(16)
        $0.numberOfLines = 2
    }
    
    private let checkBoxImageView: UIImageView = build {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var checkBoxContainerView: UIView = build {
        $0.addSubview(checkBoxImageView)
    }

    private lazy var stackView: UIStackView = build(UIStackView(arrangedSubviews: [itemIcon, itemTitle, checkBoxContainerView])) {
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confgiure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func confgiure() {
        contentView.addSubview(stackView)
        contentView.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = BaseColor.base100
        selectedBackgroundView = backgroundView
        stupLayout()
    }

    private func stupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: contentView, safe: false, left: 4, top: 0, right: 4, bottom: 0)

        itemIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            itemIcon.heightAnchor.constraint(equalToConstant: imageSize.height),
            itemIcon.widthAnchor.constraint(equalToConstant: imageSize.width)
        ]
        
        itemTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            itemTitle.heightAnchor.constraint(equalToConstant: 22)
        ]
        
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += checkBoxImageView.getLayoutConstraints(over: checkBoxContainerView, margin: 2)
        
        checkBoxContainerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            checkBoxContainerView.heightAnchor.constraint(equalToConstant: 24),
            checkBoxContainerView.widthAnchor.constraint(equalToConstant: 24)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(viewModel: CollectionPickerPickerItem) {
        itemTitle.text = viewModel.title
        itemIcon.image = viewModel.image?.uiImage
        setSelected(selected: viewModel.isSelected)
    }
    
    private func setSelected(selected: Bool) {
        checkBoxImageView.image = selected ? BaseImage.checkOn.uiImage : BaseImage.checkOff.uiImage
    }
}
