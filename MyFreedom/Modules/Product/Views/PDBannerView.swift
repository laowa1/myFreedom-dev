//
//  PDBannerView.swift
//  MyFreedom
//
//  Created by m1pro on 01.06.2022.
//

import UIKit

protocol PDBannerViewDelegate: AnyObject {

    func didSelectItem(type: CardCollectionType,at indexPath: IndexPath)
}

extension PDBannerViewDelegate {
    func didSelectItem(type: CardCollectionType = .action,at indexPath: IndexPath) {}
}

struct PDBannerViewModel: Equatable {
    let title: String
    let subtitle: String
    let image: BaseImage = .card44
}

class PDBannerView: UIView {
    
    weak var delegate: PDBannerViewDelegate?
    
    private let minimumSpacing = 16
    private var items: [PDBannerViewModel] = []

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = CGFloat(minimumSpacing)
        $0.minimumInteritemSpacing = 0
        let size = (UIScreen.main.bounds.width - 48)/2
        $0.itemSize = CGSize(width: size, height: 117)
    }

    private lazy var collectionView: UICollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout))  {
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.isPagingEnabled = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(BaseCollectionContainerCell<CDBonusBannerView>.self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        clipsToBounds = false
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        addSubview(collectionView)

        var layoutConstraints = [NSLayoutConstraint]()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 117),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func configure(items: [PDBannerViewModel]) {
        self.items = items
        collectionView.reloadData()
    }
}

extension PDBannerView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BaseCollectionContainerCell<CDBonusBannerView> = collectionView.dequeueReusableCell(for: indexPath)
        let item = items[safe: indexPath.row]
        cell.innerView.titleLabel.text = item?.title
        cell.innerView.subtitleLabel.text = item?.subtitle
        cell.innerView.imageView.image = item?.image.uiImage
        cell.addCorner()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath)
    }
}

extension PDBannerView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 0, bottom: 8, right: 0) }
    
    var containerBackgroundColor: UIColor { BaseColor.base100 }
    
    func clean() { }
}
