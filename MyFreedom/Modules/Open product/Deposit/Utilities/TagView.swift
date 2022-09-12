//
//  TagView.swift
//  MyFreedom
//
//  Created by m1 on 11.07.2022.
//

import UIKit

class TagView: UIButton {

    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    var borderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }

    var textColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    var selectedTextColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    var titleLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            titleLabel?.lineBreakMode = titleLineBreakMode
        }
    }
    var paddingY: CGFloat = 2 {
        didSet {
            titleEdgeInsets.top = paddingY
            titleEdgeInsets.bottom = paddingY
        }
    }
    var paddingX: CGFloat = 5 {
        didSet {
            titleEdgeInsets.left = paddingX
            titleEdgeInsets.right = paddingX
            updateRightInsets()
        }
    }

    var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            reloadStyles()
        }
    }

    var highlightedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }

    var selectedBorderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }

    var selectedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }

    var textFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            titleLabel?.font = textFont
        }
    }

    private func reloadStyles() {
        if isHighlighted {
            if let highlightedBackgroundColor = highlightedBackgroundColor {
                // For highlighted, if it's nil, we should not fallback to backgroundColor.
                // Instead, we keep the current color.
                backgroundColor = highlightedBackgroundColor
            }
        }
        else if isSelected {
            backgroundColor = selectedBackgroundColor ?? tagBackgroundColor
            layer.borderColor = selectedBorderColor?.cgColor ?? borderColor?.cgColor
            setTitleColor(selectedTextColor, for: UIControl.State())
        }
        else {
            backgroundColor = tagBackgroundColor
            layer.borderColor = borderColor?.cgColor
            setTitleColor(textColor, for: UIControl.State())
        }
    }

    override open var isHighlighted: Bool {
        didSet {
            reloadStyles()
        }
    }

    override open var isSelected: Bool {
        didSet {
            reloadStyles()
        }
    }

    // MARK: remove button

    let removeButton = CloseButton()

    var enableRemoveButton: Bool = false {
        didSet {
            removeButton.isHidden = !enableRemoveButton
            updateRightInsets()
        }
    }

    var removeButtonIconSize: CGFloat = 12 {
        didSet {
            removeButton.iconSize = removeButtonIconSize
            updateRightInsets()
        }
    }

    var removeIconLineWidth: CGFloat = 3 {
        didSet {
            removeButton.lineWidth = removeIconLineWidth
        }
    }
    var removeIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            removeButton.lineColor = removeIconLineColor
        }
    }

    /// Handles Tap (TouchUpInside)
    open var onTap: ((TagView) -> Void)?
    open var onLongPress: ((TagView) -> Void)?

    // MARK: - init

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    public init(title: String) {
        super.init(frame: CGRect.zero)
        setTitle(title, for: UIControl.State())

        setupView()
    }

    private func setupView() {
        titleLabel?.lineBreakMode = titleLineBreakMode

        frame.size = intrinsicContentSize
        addSubview(removeButton)
        removeButton.tagView = self

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        self.addGestureRecognizer(longPress)
    }

    @objc func longPress() {
        onLongPress?(self)
    }

    // MARK: - layout
    override open var intrinsicContentSize: CGSize {
        var size = titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: textFont]) ?? CGSize.zero
        size.height = textFont.pointSize + paddingY * 2
        size.width += paddingX * 2
        if size.width < size.height {
            size.width = size.height
        }
        if enableRemoveButton {
            size.width += removeButtonIconSize + paddingX
        }
        return size
    }

    private func updateRightInsets() {
        if enableRemoveButton {
            titleEdgeInsets.right = paddingX  + removeButtonIconSize + paddingX
        }
        else {
            titleEdgeInsets.right = paddingX
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if enableRemoveButton {
            removeButton.frame.size.width = paddingX + removeButtonIconSize + paddingX
            removeButton.frame.origin.x = self.frame.width - removeButton.frame.width
            removeButton.frame.size.height = self.frame.height
            removeButton.frame.origin.y = 0
        }
    }
}
