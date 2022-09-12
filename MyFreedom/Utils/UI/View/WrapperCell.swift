//
//  WrapperCell.swift
//  MyFreedom
//
//  Created by m1pro on 05.05.2022.
//

import UIKit

class WrapperCell<View: CleanableView>: UITableViewCell {

    private let wrapperView = UIView()
    public let innerView = View()
    private let separatorView = UIView()

    private let margin = CGFloat(16)
    private lazy var rightMargin = wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin)
    public var selectionStyleIsEnabled = true

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public func prepareForReuse() {
        super.prepareForReuse()
        innerView.clean()
        selectionStyleIsEnabled = true
        separatorView.backgroundColor = BaseColor.base200
        wrapperView.roundTop(radius: 0)
    }

//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        guard selectionStyleIsEnabled else { return super.setHighlighted(highlighted, animated: animated) }
//        setBackgroundColor(highlighted, animated: animated)
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        guard selectionStyleIsEnabled else { return super.setSelected(selected, animated: animated) }
//        setBackgroundColor(selected, animated: animated)
//    }

    private func addSubviews() {
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(innerView)
        wrapperView.addSubview(separatorView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += wrapperView.getLayoutConstraints(over: contentView, left: margin)
        layoutConstraints += [ rightMargin ]

        innerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += innerView.getLayoutConstraints(over: wrapperView, insets: innerView.contentInset)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: innerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: innerView.trailingAnchor),
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        selectionStyle = .none
        clipsToBounds = true

        contentView.backgroundColor = BaseColor.base100
        wrapperView.backgroundColor = BaseColor.base50
        
        separatorView.backgroundColor = BaseColor.base200
    }

    func setRightMargin(constant: CGFloat) {
        rightMargin.constant = -abs(constant)
    }

    func changeSeparator(color: UIColor) {
        separatorView.backgroundColor = color
    }

    func cornerTopRadius(radius: CGFloat) {
        wrapperView.roundTop(radius: radius)
    }

    func cornerBottomRadius(radius: CGFloat) {
        wrapperView.roundBottom(radius: radius)
    }
    
    func cornerRadius(radius: CGFloat) {
        wrapperView.layer.cornerRadius = radius
    }

    private func setBackgroundColor(_ selected: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let view = self else { return }
                view.wrapperView.backgroundColor = selected ? BaseColor.base200 : BaseColor.base50
            }
        } else {
            wrapperView.backgroundColor = selected ? BaseColor.base200 : BaseColor.base50
        }
    }
    
    func setWrapperViewBackground(color: UIColor) {
        wrapperView.backgroundColor = color
    }
}
