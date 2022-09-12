//
//  WrapperAccessoryCell.swift
//  MyFreedom
//
//  Created by m1pro on 16.06.2022.
//

import UIKit

protocol WACleanableView: CleanableView {
    
    var label: UILabel { get }
}

class WrapperAccessoryCell<View: WACleanableView>: UITableViewCell {

    private let wrapperView = UIView()
    public let innerView = View()
    private let separatorView = UIView()
    
    let accessoryImageView: UIImageView = build {
        $0.contentMode = .scaleAspectFill
        $0.image = BaseImage.mark.uiImage
    }
    
    private lazy var mainStack: UIStackView = build(UIStackView(arrangedSubviews: [innerView, accessoryImageView])) {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 12
    }

    private let margin = CGFloat(16)

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public func prepareForReuse() {
        super.prepareForReuse()
        accessoryImageView.image = BaseImage.mark.uiImage
        accessoryImageView.isHidden = true
        innerView.clean()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.23) { [weak self] in
            guard let view = self else { return }
            view.setSelected(selected: selected)
        }
    }

    private func addSubviews() {
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(mainStack)
        wrapperView.addSubview(separatorView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += wrapperView.getLayoutConstraints(over: contentView, safe: false, left: margin, right: margin)
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += mainStack.getLayoutConstraints(over: wrapperView, safe: false, left: 16, top: 4, right: 16, bottom: 4)
        
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            accessoryImageView.heightAnchor.constraint(equalToConstant: 24),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 24)
        ]
        
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
        selectionStyle = .gray
        let backgroundView = UIView()
        backgroundView.backgroundColor = BaseColor.base900
        selectedBackgroundView = backgroundView
        clipsToBounds = true

        contentView.backgroundColor = BaseColor.base100
        wrapperView.backgroundColor = BaseColor.base50
        
        separatorView.backgroundColor = BaseColor.base200
    }
    
    func changeSeparator(color: UIColor) {
        separatorView.backgroundColor = color
    }
    
    func setSelected(selected: Bool) {
        accessoryImageView.isHidden = !selected
        innerView.label.textColor = selected ? BaseColor.green500 : BaseColor.base900
    }
}
