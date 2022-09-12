//
//  WrapperHeaderFooterView.swift
//  MyFreedom
//
//  Created by m1pro on 05.05.2022.
//

import UIKit

class WrapperHeaderFooterView<View: WrapperHeaderFooterContentView>: UITableViewHeaderFooterView {

    private let containerView = UIView()
    public let innerView = View()
    
    public var cornerRadius: CGFloat = 16

    private let backgroundLayer = CAShapeLayer()

    private var margin = CGFloat(8)
    private lazy var topConstraint = containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
    private lazy var bottomConstraint = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)


    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()

        setCorners()
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        innerView.clean()
        layer.maskedCorners = []
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(innerView)
    }

    private func setLayoutConstraints() {

        var layoutConstraints = [NSLayoutConstraint]()
        let margins = getMargins()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += containerView.getLayoutConstraints(
            over: contentView,
            left: 16,
            top: margins.top,
            right: 16,
            bottom: margins.bottom
        )

//        topConstraint.constant = margins.top
//        bottomConstraint.constant = margins.bottom
//        layoutConstraints += [ topConstraint, bottomConstraint ]

        innerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += innerView.getLayoutConstraints(
            over: containerView,
            left: 16,
            top: innerView.marginTop,
            right: 16,
            bottom: innerView.marginBottom
        )

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func getMargins() -> (top: CGFloat, bottom: CGFloat) {
        let topMargin: CGFloat
        let bottomMargin: CGFloat
        switch innerView.type {
        case .header:
            topMargin = margin
            bottomMargin = 0
        case .footer:
            topMargin = 0
            bottomMargin = margin
        }

        return (topMargin, bottomMargin)
    }

    private func stylize() {
        backgroundLayer.fillColor = BaseColor.base50.cgColor
        clipsToBounds = true

        containerView.layer.insertSublayer(backgroundLayer, at: 0)
    }

    private func setCorners() {
        let roundedRect: CGRect
        switch innerView.type {
        case .header: roundedRect = CGRect(x: 0, y: 0, width: bounds.width - 2 * 16, height: bounds.height - margin)
        case .footer: roundedRect = CGRect(x: 0, y: -margin, width: bounds.width - 2 * 16, height: bounds.height)
        }

        let maskPath = UIBezierPath(
            roundedRect: roundedRect,
            byRoundingCorners: innerView.type.corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        backgroundLayer.path = maskPath.cgPath
    }

    func updateBackgroundColor(color: UIColor) {
        backgroundLayer.fillColor = color.cgColor
    }

    func set(customMargin: CGFloat) {
        margin = customMargin
        let margins = getMargins()
        topConstraint.constant = margins.top
        bottomConstraint.constant = -margins.bottom
    }
}
