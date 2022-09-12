//
//  StartPageViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 10.03.2022.
//

import UIKit
import InputMask

class StoriesViewController: BaseViewController {
    
    var router: StoriesRouterInput?
    var interactor: StoriesInteractorInput?
    weak var delegate: StoriesDelegate? {
        didSet {
            guard let delegate = delegate else { return }
            skipButton.isHidden = !delegate.showNextButton
            closeButton.isHidden = !delegate.showCloseButton
        }
    }
    
    private let storyDuration: Double = 5
    private var itemCount: Int {
        interactor?.numberOfItems() ?? 0
    }
    private var currentVisibleIndex: IndexPath? {
        storiesContentCollectionView.indexPathsForVisibleItems.first.flatMap({IndexPath(row: $0.row, section: $0.section)})
    }
    private var progressView = StoriesProgressView()
    
    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.itemSize = CGSize(width: UIScreen.main.bounds.size.width,
                             height: UIScreen.main.bounds.size.height)
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }

    private lazy var closeButtonBackground: UIView = build {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
        $0.alpha = 0.05
    }

    private lazy var closeButton: UIButton = build {
        let buttonImage = BaseImage.close.template?.resized(to: CGSize(width: 8.3, height: 8.3)).withTintColor(.white)
        $0.addSubview(closeButtonBackground)
        $0.setImage(buttonImage, for: .normal)
    }
    
    private lazy var storiesContentCollectionView: UICollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout)) {
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.register(StoryContentCollectionViewCell.self)
        $0.isPagingEnabled = false
        $0.isScrollEnabled = false
        $0.bounces = false
        $0.backgroundColor = .clear
    }
    
    private lazy var skipButton = build(ButtonFactory().getWhiteButton()) {
        $0.layer.cornerRadius = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("Начать", for: .normal)
        $0.addTarget(self, action: #selector(beginAction), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        configureSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let visibleIndex = currentVisibleIndex else { return }
        animateScroll(index: visibleIndex)
    }

    override func viewDidDisappear(_ animated: Bool) {
        progressView.resetDisplayedList()
        progressView.reloadView()
        storiesContentCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
    }
    
    private func configureSubviews() {
        addSubviews()
        addLayout()
        addActions()

        if let interactor = interactor {
            interactor.fetchStoriesData()
            interactor.configureButtons()
        }
        progressView.setItemCount(itemCount)
    }

    private func addSubviews() {
        view.addSubview(storiesContentCollectionView)
        view.addSubview(progressView)
        view.addSubview(closeButton)
        view.addSubview(skipButton)
    }

    private func addLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        storiesContentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += storiesContentCollectionView.getLayoutConstraints(over: view, safe: false)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            progressView.heightAnchor.constraint(equalToConstant: 2),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]

        closeButtonBackground.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += closeButtonBackground.getLayoutConstraints(over: closeButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]

        progressView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            skipButton.heightAnchor.constraint(equalToConstant: 52),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func addActions() {
        storiesContentCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapScroll)))
        storiesContentCollectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
        closeButtonBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beginAction)))
        storiesContentCollectionView.addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
        storiesContentCollectionView.addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
        storiesContentCollectionView.addGestureRecognizer(createSwipeGestureRecognizer(for: .up))
        storiesContentCollectionView.addGestureRecognizer(createSwipeGestureRecognizer(for: .down))
    }
}

extension StoriesViewController: StoriesViewInput {

    func storyButtons(title: String, image: BaseImage?) {
        skipButton.setImage(image?.uiImage, for: .normal)
        skipButton.setTitle(title, for: .normal)
    }
}

extension StoriesViewController {
    
    @objc private func tapScroll(touch: UIGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        if touchPoint.x > (self.view.frame.width/2) {
            scrollToNext()
        } else {
            scrollToPervous()
        }
    }
    
    @objc private func scrollToNext(animate: Bool = false) {
        guard let visibleIndex = currentVisibleIndex else { return }
        let nextIndex = IndexPath(row: visibleIndex.row + 1, section: 0)
        if nextIndex.row < itemCount {
            scrollTo(index: nextIndex, from: visibleIndex, animate: animate)
        } else {
            beginAction()
        }
    }
    
    private func scrollToPervous(animate: Bool = false) {
        guard let visibleIndex = currentVisibleIndex else { return }
        let nextIndex = IndexPath(row: visibleIndex.row - 1, section: 0)
        if nextIndex.row >= 0 && nextIndex.row < itemCount {
            progressView.changeWidthOf(index: visibleIndex, to: 0)
            scrollTo(index: nextIndex, from: visibleIndex, animate: animate)
        }
    }
    
    private func scrollTo(index scrollIndex: IndexPath, from visibleIndex: IndexPath, animate: Bool = false) {
        storiesContentCollectionView.scrollToItem(at: scrollIndex, at: .right, animated: animate)
        progressView.changeWidthOf(index: scrollIndex, to: 0)
        progressView.removeAnimation(in: visibleIndex)
        animateScroll(index: scrollIndex)
    }
    
    private func animateScroll(index: IndexPath) {
        UIView.animate(withDuration: storyDuration,
                       delay: 0,
                       options: [],
                       animations: { [weak self] in
            self?.progressView.changeWidthOf(index: index, to: 1)} ) { finished in
                if finished {
                    self.scrollToNext()
                }
            }
    }
    
    @objc private func beginAction() {
        if delegate?.routeToAuth == false {
            router?.routeToBack()
            delegate?.nextButtonAction()
        } else {
            router?.routeToAuthPage()
        }
    }
    
    @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            pauseAnimation()
        } else if gestureRecognizer.state == .ended {
            resumeAnimation()
        }
    }

    @objc private func handleSwipe(swipeGestureRecognizer: UISwipeGestureRecognizer) {

        switch swipeGestureRecognizer.direction {
        case .up,.down:
            beginAction()
        case .right:
            scrollToPervous(animate: true)
        case .left:
            scrollToNext(animate: true)
        default:
            return
        }
    }
    
    private func pauseAnimation() {
        let pausedTime = view.layer.convertTime(CACurrentMediaTime(), from: nil)
        view.layer.speed = 0.0
        view.layer.timeOffset = pausedTime
        view.isUserInteractionEnabled = false
    }
    
    private func resumeAnimation() {
        view.isUserInteractionEnabled = true
        let pausedTime = view.layer.timeOffset
        view.layer.speed = 1.0
        view.layer.timeOffset = 0.0
        view.layer.beginTime = 0.0
        let timeSincePause = view.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        view.layer.beginTime = timeSincePause
    }

    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGestureRecognizer.direction = direction
        swipeGestureRecognizer.numberOfTouchesRequired = 1
        return swipeGestureRecognizer
    }
}

extension StoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StoryContentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let item = interactor?.getStoryItem(for: indexPath.row) else {
            return collectionView.dequeueReusableCell(for: indexPath)
        }
        cell.setContent(data: item)
        return cell
    }
}
