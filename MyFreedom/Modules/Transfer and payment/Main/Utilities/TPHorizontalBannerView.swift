//
//  TPHorizontalBannerView.swift
//  MyFreedom
//
//  Created by m1 on 04.07.2022.
//

import UIKit

protocol TPHorizontalBannerViewDelegate: AnyObject {

    func didSelectItem(at indexPath: IndexPath)
}

class TPHorizontalBannerView: UIView {

    weak var delegate: TPHorizontalBannerViewDelegate?

    private let minimumSpacing = 10
    private var items: [TPIViewModel] = []

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = CGFloat(minimumSpacing)
        $0.minimumInteritemSpacing = 0
        $0.itemSize = CGSize(width: 118, height: 110)
    }

    private lazy var collectionView: UICollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout))  {
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.isPagingEnabled = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(BannerImage40ViewItemCell.self)
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
            collectionView.heightAnchor.constraint(equalToConstant: 110),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    func configure(items: [TPIViewModel]) {
        self.items = items
        collectionView.reloadData()
    }
}

extension TPHorizontalBannerView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BannerImage40ViewItemCell = collectionView.dequeueReusableCell(for: indexPath)

        let item = items[safe: indexPath.row]
        cell.titleLabel.text = item?.title
        cell.imageView.image = item?.icon?.uiImage
        cell.set(height: 32)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath)
    }
}

extension TPHorizontalBannerView: CleanableView {

    var contentInset: UIEdgeInsets { .init(top: 0, left: 0, bottom: 24, right: 0) }

    func clean() { }
}
