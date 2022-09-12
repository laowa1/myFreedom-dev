//
//  TopProgressView.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.03.2022.
//

import UIKit

class StoriesProgressView: UIView {

    private var displayedStories = [Bool]()
    private var availableWidth = UIScreen.main.bounds.width - CGFloat((32))
    private let minimumSpacing = 4
    private var itemCount = 0
    private var itemWidth: CGFloat {
        if itemCount > 1 {
            availableWidth = availableWidth - CGFloat(minimumSpacing * (itemCount-1))
            return availableWidth/CGFloat(itemCount)
        }
        return availableWidth
    }

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = CGFloat(minimumSpacing)
        $0.minimumInteritemSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.itemSize = CGSize(width: availableWidth, height: 4)
    }

    private lazy var progressCollectionView: UICollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout))  {
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(ProgressCollectionViewCell.self)
        $0.isScrollEnabled = false
        $0.isPagingEnabled = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(progressCollectionView)
        progressCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(progressCollectionView.getLayoutConstraints(over: self, safe: false))
    }

    func changeWidthOf(index: IndexPath, to size: Int) {
        guard let cell = progressCollectionView.cellForItem(at: index) as? ProgressCollectionViewCell else { return }
        displayedStories[index.row] = size > 0
        cell.changeWidth(to: size)
    }

    func removeAnimation(in index: IndexPath) {
        guard let cell = progressCollectionView.cellForItem(at: index) as? ProgressCollectionViewCell else { return }
        cell.removeAnimation()
    }
}

extension StoriesProgressView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProgressCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let width = displayedStories[indexPath.row] ? 1 : 0
        cell.changeWidth(to: width)
        return cell
    }

    func setItemCount(_ count: Int) {
        itemCount = count
        displayedStories = [Bool].init(repeating: false, count: count)
        layout.itemSize = CGSize(width: itemWidth, height: 4)
        layout.invalidateLayout()
        progressCollectionView.reloadData()
    }

    func reloadView() {
        progressCollectionView.reloadData()
    }

    func resetDisplayedList() {
        for index in  displayedStories.indices {
            displayedStories[index] = false
        }
    }
}
