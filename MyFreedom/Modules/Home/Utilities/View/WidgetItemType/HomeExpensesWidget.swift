//
//  HomeExpensesItem.swift
//  MyFreedom
//
//  Created by &&TairoV on 4/30/22.
//

import UIKit

class HomeExpensesWidget: UIView {

    private let titleLabel = PaddingLabel()
    private let amountLabel = PaddingLabel()
    private let progressStack = UIStackView()
    private var availableWidth = UIScreen.main.bounds.width - CGFloat((64))

    private lazy var contentStackView: UIStackView = build(UIStackView(arrangedSubviews: [infoStackView, progressStack])) {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 8
    }

    private lazy var infoStackView: UIStackView = build(UIStackView(arrangedSubviews: [titleLabel, amountLabel])) {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 4
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setuplayout()
        stylize()
    }

    func configure(model: WidgetViewModel, items: [ExpenseModel]) {
        titleLabel.text = model.title
        amountLabel.text = model.amount

        let sum = items.map { $0.partition }.reduce(0, +)
        
        for item in items {
            let view = UIView()
            let precent: CGFloat = item.partition/sum
            let width = (precent * availableWidth).rounded()

            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
            view.layer.cornerRadius = 3
            view.backgroundColor = item.color
            progressStack.addArrangedSubview(view)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(contentStackView)
    }

    private func setuplayout() {
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [progressStack.heightAnchor.constraint(equalToConstant: 8)])

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(contentStackView.getLayoutConstraints(over: self, left: 16, top: 16, right: 16, bottom: 16))
    }

    private func stylize() {
        backgroundColor = .white
        layer.cornerRadius = 12

        progressStack.spacing = 2.0
        progressStack.distribution = .fillProportionally
        progressStack.axis = .horizontal

        titleLabel.text = "Нет трат за апрель"
        titleLabel.textAlignment = .left
        titleLabel.font = BaseFont.regular.withSize(16)
        titleLabel.textColor = .black

        amountLabel.font = BaseFont.regular.withSize(16)
        amountLabel.text = "0,00 ₸"
        amountLabel.textAlignment = .right
        amountLabel.textColor = .black
    }
}

extension HomeExpensesWidget: CleanableView {

    var contentInset: UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) }

    func clean() {
        progressStack.removeAllArrangedSubviews()
    }
}
