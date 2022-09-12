//
//  OffersView.swift
//  MyFreedom
//
//  Created by m1pro on 01.06.2022.
//

import UIKit

protocol OffersViewDelegate: AnyObject {

    func didSelectItem(at indexPath: IndexPath, currentItemFrame: CGRect?)
}

struct OffersViewModel: Equatable {
    let title: String
    let image: BaseImage = .smallBanner40
}

class OffersView: UIView {
    
    weak var delegate: OffersViewDelegate?
    
    private let minimumSpacing = 8
    private var items: [OffersViewModel] = []
    
    private var titleLabel: UILabel = build {
        $0.textColor = BaseColor.base500
        $0.font = BaseFont.medium.withSize(13)
        $0.text = "Цифровые документы"
    }

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = CGFloat(minimumSpacing)
        $0.minimumInteritemSpacing = 0
        $0.itemSize = CGSize(width: 140, height: 140)
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
        addSubview(titleLabel)
        addSubview(collectionView)

        var layoutConstraints = [NSLayoutConstraint]()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ]
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 140),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func configure(items: [OffersViewModel]) {
        self.items = items
        collectionView.reloadData()
    }
}

extension OffersView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BannerImage40ViewItemCell = collectionView.dequeueReusableCell(for: indexPath)
        
        let item = items[safe: indexPath.row]
        cell.titleLabel.text = item?.title
        cell.imageView.image = item?.image.uiImage
        cell.closeButton.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var currentItemFrame: CGRect? = nil
        
        if let frame = collectionView.cellForItem(at: indexPath)?.frame {
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            currentItemFrame = collectionView.convert(frame, to: keyWindow)
        }
        delegate?.didSelectItem(at: indexPath, currentItemFrame: currentItemFrame)
    }
}

extension OffersView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 0, bottom: 0, right: 0) }
    
    func clean() { }
}
