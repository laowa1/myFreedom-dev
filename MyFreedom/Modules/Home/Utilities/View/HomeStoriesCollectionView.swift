//
//  HomeStoriesView.swift
//  MyFreedom
//
//  Created by &&TairoV on 29.04.2022.
//

import UIKit

protocol HomeStoriesViewDelegate: AnyObject {

    func didSelectItem(at indexPath: IndexPath, currentItemFrame: CGRect?)
}

class HomeStoriesCollectionView: UIView {
    
    weak var delegate: HomeStoriesViewDelegate?
    
    var isLoading = true {
        didSet {
            if isLoading {
                items = []
            }
            reload()
        }
    }
    private var shimmerCount: Int { 4 }
    
    private var items: [BaseImage] = []

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 4
        $0.minimumInteritemSpacing = 0
        $0.itemSize = CGSize(width: 92, height: 92)
    }

    private lazy var collectionView: UICollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout))  {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.isPagingEnabled = false
        $0.isUserInteractionEnabled = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        $0.dataSource = self
        $0.delegate = self
        $0.register(BaseCollectionContainerCell<HomeStoriesViewItem>.self)
        $0.register(BaseCollectionContainerCell<ShimmerView>.self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints = collectionView.getLayoutConstraints(over: self)
        layoutConstraints += [collectionView.heightAnchor.constraint(equalToConstant: 92)]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func reload() {
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = !isLoading
        if isLoading {
            collectionView.rightToLeft()
        }
    }
    
    func configure(with items: [BaseImage]) {
        self.items = items
        isLoading = false
    }
}

extension HomeStoriesCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? shimmerCount : items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
            let cell: BaseCollectionContainerCell<ShimmerView> = collectionView.dequeueReusableCell(for: indexPath)
            cell.innerView.gradientLayer.cornerRadius = 16
            cell.innerView.startAnimating()
            return cell
        } else {
            let cell: BaseCollectionContainerCell<HomeStoriesViewItem> = collectionView.dequeueReusableCell(for: indexPath)
            cell.innerView.imageView.image = items[safe: indexPath.row]?.uiImage
            cell.addCorner(radius: 16)
            return cell
        }
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

extension HomeStoriesCollectionView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 0, bottom: 0, right: 0) }
    
    func clean() { }
}
