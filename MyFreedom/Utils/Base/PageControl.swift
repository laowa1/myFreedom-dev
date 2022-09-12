//
//  PagerView.swift
//  MyFreedom
//
//  Created by &&TairoV on 29.04.2022.
//

import UIKit

class PageControl: UIView {

    private let stackView = UIStackView()
    private let itemMaxWidth = CGFloat(6)
    public var currentPageIndicatorTintColor = BaseColor.base700
    public var pageIndicatorTintColor = BaseColor.base300

    public var currentPage = 0 {
        didSet {
            stackView.arrangedSubviews.forEach { $0.backgroundColor = pageIndicatorTintColor }
            if stackView.arrangedSubviews.count <= currentPage { return }
            stackView.arrangedSubviews[currentPage].backgroundColor = currentPageIndicatorTintColor
        }
    }

    public var numberOfPages = 0 {
        didSet { setControlItems() }
    }

    public var hideForSinglePage = false {
        didSet { isHidden = numberOfPages <= 1 && hideForSinglePage }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setControlItems()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.layoutByCentering(over: self)
        stylize()
    }

    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func stylize() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }

    private func setControlItems() {
        guard numberOfPages > 0 &&
              frame.width > 0 &&
              !(numberOfPages == 1 && hideForSinglePage) else {
            isHidden = true
            return
        }

        removeControls()

        stackView.spacing = 4
        let possibleWidth = frame.width / CGFloat(numberOfPages) - stackView.spacing
        let itemWidth = min(itemMaxWidth, possibleWidth)
        for _ in 0..<numberOfPages {
            stackView.addArrangedSubview(getItemView(ofWidth: itemWidth))
        }

        if currentPage >= numberOfPages { currentPage = 0 }
        stackView.arrangedSubviews[currentPage].backgroundColor = currentPageIndicatorTintColor
        isHidden = false
    }

    private func removeControls() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    private func getItemView(ofWidth width: CGFloat) -> UIView {
        let view = UIView()

        view.backgroundColor = pageIndicatorTintColor
        view.layer.cornerRadius = width / 2

        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: width),
            view.heightAnchor.constraint(equalToConstant: width)
        ])

        return view
    }
}
