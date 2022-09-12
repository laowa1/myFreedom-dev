//
//  DigitalDocumentsView.swift
//  MyFreedom
//
//  Created by m1pro on 16.05.2022.
//

import UIKit

protocol DigitalDocumentsViewDelegate: AnyObject {

    func didSelectItem(at indexPath: IndexPath, currentItemFrame: CGRect?)
}

struct DigitalDocumentsModel {
    let title: String
    let image: BaseImage = .digitalDocuments
}

class DigitalDocumentsView: UIView {
    
    weak var delegate: DigitalDocumentsViewDelegate?
    
    private let minimumSpacing = 8
    private var items = [
        DigitalDocumentsModel(title: "Удостоверение личности"),
        DigitalDocumentsModel(title: "Паспорт вакцинации"),
        DigitalDocumentsModel(title: "Водительские права")
    ]
    
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
        $0.itemSize = CGSize(width: 116, height: 108)
    }

    private lazy var collectionView: UICollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout))  {
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(BannerImage40ViewItemCell.self)
        $0.isScrollEnabled = true
        $0.isPagingEnabled = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
            collectionView.heightAnchor.constraint(equalToConstant: 108),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension DigitalDocumentsView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BannerImage40ViewItemCell = collectionView.dequeueReusableCell(for: indexPath)
        
        let item = items[safe: indexPath.row]
        cell.titleLabel.text = item?.title
        cell.imageView.image = item?.image.uiImage
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

extension DigitalDocumentsView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 0, bottom: 0, right: 0) }
    
    func clean() { }
}
