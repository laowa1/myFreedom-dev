//
//  HomeStocksWidget.swift
//  MyFreedom
//
//  Created by &&TairoV on 31.05.2022.
//

import UIKit

class HomeStocksWidget: UIView {

    private let stockNameLabel = PaddingLabel()
    private let stockCountLabel = PaddingLabel()
    private let stockPrice = PaddingLabel()
    private let stockCount = PaddingLabel()

    private let stockIcon = UIImageView()

    private lazy var contentStackView: UIStackView = build(UIStackView(arrangedSubviews: [stockIcon, infoStackView])) {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }

    private lazy var infoStackView: UIStackView = build(UIStackView(arrangedSubviews: [stockNameStack, stockCountStack])) {
        $0.axis = .vertical
        $0.alignment = .fill
    }

    private lazy var stockNameStack: UIStackView = build((UIStackView(arrangedSubviews: [stockNameLabel, stockCountLabel]))) {
        $0.axis = .horizontal
        $0.spacing = 4
    }

    private lazy var stockCountStack: UIStackView = build((UIStackView(arrangedSubviews: [stockPrice, stockCount]))) {
        $0.axis = .horizontal
        $0.spacing = 4
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setuplayout()
        stylize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: WidgetViewModel, count: String?, stockStatus: String?, stockShortTitle: String? ) {

        let attributedString = getAttributedString(stockName: model.title, stockShortName: stockShortTitle, stockPrice: model.amount, stockPriceStatus: stockStatus)
        stockIcon.image = model.icon
        stockNameLabel.attributedText  = attributedString.stockName
        stockPrice.attributedText = attributedString.storckPrice
        stockCountLabel.text = model.subtitle
        stockCount.text = count
    }

    private func addSubviews() {
        addSubview(contentStackView)
    }

    private func setuplayout() {
        var layoutConstrints = [NSLayoutConstraint]()

        stockIcon.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += [
            stockIcon.widthAnchor.constraint(equalToConstant: 32),
            stockIcon.heightAnchor.constraint(equalToConstant: 32)
        ]

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstrints += contentStackView.getLayoutConstraints(over: self, left: 16, top: 16, right: 16, bottom: 16)

        NSLayoutConstraint.activate(layoutConstrints)
    }

    private func stylize() {
        backgroundColor = .white
        layer.cornerRadius = 12

        stockCountLabel.font = BaseFont.medium.withSize(11)
        stockCountLabel.textAlignment = .right
        stockCountLabel.textColor = BaseColor.base500

        stockCount.font = BaseFont.medium.withSize(13)
        stockCount.textAlignment = .right
        stockCount.textColor = BaseColor.base900
    }

    private func getAttributedString(stockName: String? = "Freedom Holding", stockShortName: String? = "FRHC", stockPrice: String?, stockPriceStatus: String?) -> (stockName:NSAttributedString, storckPrice: NSAttributedString) {
        let stockNameAttr = NSMutableAttributedString(string: stockShortName ?? "", attributes: [
            .font: BaseFont.medium.withSize(11),
            .foregroundColor: BaseColor.base900
        ])
        stockNameAttr.append(NSAttributedString(string: " " + (stockName ?? ""), attributes: [
            .font: BaseFont.medium.withSize(11),
            .foregroundColor: BaseColor.base500
        ]))

        let stockPriceAttr = NSMutableAttributedString(string: stockPrice ?? "", attributes: [
            .font: BaseFont.medium.withSize(13),
            .foregroundColor: BaseColor.base900
        ])
        stockPriceAttr.append(NSAttributedString(string: " " + (stockPriceStatus ?? ""), attributes: [
            .font: BaseFont.medium.withSize(11),
            .foregroundColor: BaseColor.green500
        ]))

        return (stockNameAttr, stockPriceAttr)
    }
}

extension HomeStocksWidget: CleanableView {

    func clean() { }
}
