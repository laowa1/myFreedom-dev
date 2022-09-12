//
//  CalendarDayCell.swift
//  MyFreedom
//
//  Created by m1pro on 16.06.2022.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {

    enum CoverMode {
        case left, right, full, none
    }

    private let coverView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()

    private lazy var coverViewLeftConstraint = coverView.leftAnchor.constraint(
        equalTo: contentView.leftAnchor,
        constant: -0.5
    )
    private lazy var coverViewLeftToCenterXConstraint = coverView.leftAnchor.constraint(
        equalTo: containerView.leftAnchor,
        constant: -2
    )
    private lazy var coverViewRightToCenterXConstraint = coverView.rightAnchor.constraint(
        equalTo: containerView.rightAnchor,
        constant: 2
    )
    private lazy var coverViewRightConstraint = coverView.rightAnchor.constraint(
        equalTo: contentView.rightAnchor,
        constant: 0.5
    )

    var isDaySelected: Bool = false {
        didSet {
            changeViewState()
        }
    }

    var coverMode: CoverMode = .none {
        didSet {
            layoutCoverView()
        }
    }

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var font: UIFont {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    }
    
    var textColor: UIColor {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    var isEnabled: Bool {
        get { isUserInteractionEnabled }
        set {
            isUserInteractionEnabled = newValue
            titleLabel.textColor = newValue ? BaseColor.base900 : BaseColor.base500
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        isDaySelected = false
        coverMode = .none
        title = nil
        font = BaseFont.semibold.withSize(18)
        isEnabled = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        contentView.addSubview(coverView)
        contentView.addSubview(containerView)
        contentView.addSubview(titleLabel)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        coverViewLeftConstraint.priority = .defaultLow
        coverViewRightConstraint.priority = .defaultLow
        coverViewLeftToCenterXConstraint.priority = .defaultLow
        coverViewRightToCenterXConstraint.priority = .defaultLow

        coverView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            containerView.widthAnchor.constraint(equalTo: containerView.heightAnchor)
        ]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += titleLabel.getLayoutConstraints(over: contentView)

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        backgroundColor = BaseColor.base50
        
        coverView.alpha = 0
        coverView.backgroundColor = BaseColor.base200
        coverView.clipsToBounds = true
        coverView.layer.cornerRadius = 20

        containerView.backgroundColor = BaseColor.green500
        containerView.alpha = 0
        containerView.layer.cornerRadius = 18
        containerView.clipsToBounds = true

        titleLabel.font = BaseFont.semibold.withSize(18)
        titleLabel.textColor = BaseColor.base900
        titleLabel.textAlignment = .center
    }

    private func layoutCoverView() {
        coverView.alpha = 1

        switch coverMode {
        case .left:
            coverViewLeftConstraint.isActive = true
            coverViewRightToCenterXConstraint.isActive = true
            coverView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .right:
            coverViewLeftToCenterXConstraint.isActive = true
            coverViewRightConstraint.isActive = true
            coverView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .full:
            coverViewLeftConstraint.isActive = true
            coverViewRightConstraint.isActive = true
            coverView.layer.maskedCorners = []
        case .none:
            coverView.alpha = 0
            coverViewLeftConstraint.isActive = false
            coverViewLeftToCenterXConstraint.isActive = false
            coverViewRightConstraint.isActive = false
            coverViewRightToCenterXConstraint.isActive = false
            coverView.layer.maskedCorners = []
        }

        contentView.layoutIfNeeded()
    }

    private func changeViewState() {
        containerView.alpha = isDaySelected ? 1 : 0
        titleLabel.textColor =
            isDaySelected ? BaseColor.base100 : isEnabled ? BaseColor.base900 : BaseColor.base500
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
