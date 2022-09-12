//
//  PDBAccountsView.swift
//  MyFreedom
//
//  Created by m1pro on 22.06.2022.
//

import UIKit

class PDBAccountsView: UIView {
    
    weak var delegate: PDBannerViewDelegate?
    
    private let minimumSpacing = 8
    private var items: [PDActionViewModel] = []
    
    private let gradientLayer: CAGradientLayer = build {
        $0.colors = [BaseColor._36A75D.cgColor, BaseColor._3E847E.cgColor]
        $0.locations = [0, 1]
        $0.startPoint = CGPoint(x: 1, y: 0)
        $0.endPoint = CGPoint(x: 0, y: 1)
    }
    
    private lazy var stackView: UIStackView = build {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.addArrangedSubviews(titleVerticalStack, collectionView)
        $0.setCustomSpacing(32, after: titleVerticalStack)
    }
    
    private lazy var titleVerticalStack: UIStackView = build {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
        $0.addArrangedSubviews(titleLabel)
    }
    
    private let titleLabel: PaddingLabel = build {
        $0.font = BaseFont.bold.withSize(32)
        $0.textColor = BaseColor.base50
        $0.text = "1000 000,15 ₸"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.textAlignment = .center
        $0.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = CGFloat(minimumSpacing)
        $0.minimumInteritemSpacing = 0
    }

    private lazy var collectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout))  {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(BaseCollectionContainerCell<PDActionButtonView>.self)
        
        $0.dataSource = self
        $0.delegate = self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.insertSublayer(gradientLayer, at: 0)
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }

    private func configureSubviews() {
        addSubview(stackView)
    
        var layoutConstraints = [NSLayoutConstraint]()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints +=  [
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.heightAnchor.constraint(equalToConstant: 88)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.heightAnchor.constraint(equalToConstant: 32)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func configure(items: [PDActionViewModel]) {
        self.items = items
        collectionView.reloadData()
        layout.itemSize = CGSize(width: (UIView.screenWidth-40)/2, height: 88)
    }
}

extension PDBAccountsView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BaseCollectionContainerCell<PDActionButtonView> = collectionView.dequeueReusableCell(for: indexPath)
        let item = items[safe: indexPath.row]
        cell.innerView.titleLabel.text = item?.title
        cell.innerView.imageView.image = item?.image.uiImage
        cell.addCorner()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath)
    }
}
