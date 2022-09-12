//
//  SelectionListView.swift
//  MyFreedom
//
//  Created by m1 on 07.07.2022.
//

import UIKit

protocol SelectionListViewDelegate: AnyObject {

    func didSelectItem(at index: Int)
}

class SelectionListView: UIView {

    private lazy var stackView: UIStackView = build {
        $0.addArrangedSubviews(titleLabel, tagsView)
        $0.axis = .vertical
        $0.spacing = 12
    }
    let titleLabel: UILabel = build {
        $0.textColor = BaseColor.base700
        $0.font = BaseFont.medium.withSize(13)
    }
    private lazy var tagsView: TagListView = build {
        $0.textFont = BaseFont.medium.withSize(14)
        $0.alignment = .leading
        $0.minWidth = 48
        $0.paddingX = 16
        $0.paddingY = 8
        $0.marginX = 8
        $0.marginY = 12
        $0.borderWidth = 1
        $0.borderColor = BaseColor.base700
        $0.cornerRadius = 12
        $0.tagSelectedBackgroundColor = BaseColor.base800
        $0.tagBackgroundColor = .clear
        $0.textColor = BaseColor.base700
        $0.selectedTextColor = BaseColor.base50
//        tagListView.insertTag("This should be the second tag", at: 1)

//        tagListView.setTitle("New Title", at: 6) // to replace the title a tag

//        tagListView.removeTag("meow") // all tags with title “meow” will be removed
//        tagListView.removeAllTags()

    }
    private var items: [SelectionItemModel] = []

    weak var delegate: SelectionListViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        setLayoutConstraints()
        stylize()
        setActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        addSubviews(stackView)
        setLayoutConstraints()
        stylize()
        setActions()
    }

    func set(items: [SelectionItemModel]) {
        self.items = items
        let items = tagsView.addTags(items.map { $0.title })
        items.first?.isSelected = true
        layoutIfNeeded()
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self, safe: false, top: 8, bottom: 0)

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        backgroundColor = .clear
    }

    private func setActions() { }
}

extension SelectionListView: CleanableView {

    var contentInset: UIEdgeInsets { .init(top: 12, left: 16, bottom: 16, right: 12) }

    func clean() {
        titleLabel.text = nil
    }
}
