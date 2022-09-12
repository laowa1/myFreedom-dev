//
//  HomeWidgetsCollectionView.swift
//  MyFreedom
//
//  Created by &&TairoV on 29.04.2022.
//

import UIKit

class HomeWidgetsCollectionView: UIView {

    private var items = [WidgetViewModel]()
    private var itemHeight: CGFloat = 69

    private var currentVisibleIndex: IndexPath? {
        collectionView.indexPathsForVisibleItems.first.flatMap({IndexPath(row: $0.row, section: $0.section)})
    }
    var timeInterval: TimeInterval = 5

    /// Is Automatic rotation, default is true
    var isAutoRotation: Bool = true {
        didSet {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private var currentIndex: Int = 0
    private var timer: Timer?
    
    private let pageControl = PageControl()
    private var index = 0
    
    private var itemAddSpacing: CGFloat { layout.itemSize.width + layout.minimumLineSpacing }

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.itemSize = CGSize(width: (UIScreen.main.bounds.size.width), height: itemHeight)
    }

    private lazy var collectionView: UICollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout)) {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
        $0.register(BaseCollectionContainerCell<HomeExpensesWidget>.self)
        $0.register(BaseCollectionContainerCell<HomeCreditsWidgets>.self)
        $0.register(BaseCollectionContainerCell<HomeStocksWidget>.self)
        
        $0.dataSource = self
        $0.delegate = self
    }

    func configure(items: [WidgetViewModel]) {
        self.items = items

        pageControl.numberOfPages = items.count
        pageControl.currentPage = 0

        collectionView.reloadData()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayout()
        stylize()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(collectionView)
        addSubview(pageControl)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 69)
        ]

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            pageControl.heightAnchor.constraint(equalToConstant: 10)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        backgroundColor = .clear
        
        collectionView.clipsToBounds = false
    }
    
    func configure() {
        stopTimer()
        guard isAutoRotation else { return }
        startTimer()
    }
    
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScrollAction), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    @objc private func autoScrollAction() {
        DispatchQueue.main.async {
            var nextIndex: Int = 0
            
            if self.currentIndex + 1 >= self.items.count {
                nextIndex = 0
            } else {
                nextIndex = self.currentIndex + 1
            }
            self.scrollToItemFor(index: nextIndex, animated: true)
            self.collectionView.isUserInteractionEnabled = false
        }
    }

    private func scrollToItemFor(index: Int, animated: Bool) {
        let nextOffset = CGPoint(x: CGFloat(index) * itemAddSpacing - contentInset.left, y: -self.contentInset.top)
        
        if animated {
            collectionView.setContentOffset(nextOffset, animated: animated)
        } else {
            collectionView.contentOffset = nextOffset
        }
    }
}

extension HomeWidgetsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]

        switch item.type {
        case .expense(let items):
            let cell: BaseCollectionContainerCell<HomeExpensesWidget> = collectionView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(model: item, items: items)
            return cell
        case .stocks(let stockCount, let stockStatus, let stockShortTitle):
            let cell: BaseCollectionContainerCell<HomeStocksWidget> = collectionView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(model: item, count: stockCount, stockStatus: stockStatus, stockShortTitle: stockShortTitle)
            return cell
        case .credit(let buttonTitle):
            let cell: BaseCollectionContainerCell<HomeCreditsWidgets> = collectionView.dequeueReusableCell(for: indexPath)
            cell.innerView.configure(model: item, buttonTitle: buttonTitle)
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        pageControl.currentPage = indexPath.row
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard isAutoRotation else {
            stopTimer()
            return
        }
        startTimer()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.isUserInteractionEnabled = true
        let index = currentIndex % items.count
        scrollToItemFor(index: index, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard itemAddSpacing > 0 else { return }
        currentIndex = Int((scrollView.contentOffset.x + contentInset.left) / self.itemAddSpacing)
    }
}

extension HomeWidgetsCollectionView: CleanableView {
    
    var contentInset: UIEdgeInsets { .init(top: 0, left: 0, bottom: 0, right: 0) }
    
    func clean() { }
}
