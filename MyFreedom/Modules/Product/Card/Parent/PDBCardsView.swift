//
//  PDBCardsView.swift
//  MyFreedom
//
//  Created by m1pro on 22.06.2022.
//

import UIKit
import Lottie

enum CardCollectionType {
    case action, theme
}

class PDBCardsView: UIView {
    
    weak var delegate: PDBannerViewDelegate?
    var saveThemeAction: (() -> Void)?
    
    private let minimumSpacing = 8
    private let themeMinimumSpacing = 34
    private var items: [PDActionViewModel] = []
    private var gradientColors = GradientColor.allCases
    private var selectedColor = GradientColor.green
    
    private let gradientLayer: CAGradientLayer = build {
        $0.locations = [0, 1]
        $0.startPoint = CGPoint(x: 1, y: 0)
        $0.endPoint = CGPoint(x: 0, y: 1)
    }
    
    private lazy var stackView: UIStackView = build {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.addArrangedSubviews(titleVerticalStack, collectionView, bottomLabel)
        $0.setCustomSpacing(32, after: titleVerticalStack)
        $0.setCustomSpacing(24, after: collectionView)
    }
    
    private lazy var titleVerticalStack: UIStackView = build {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
        $0.addArrangedSubviews(titleLabel, subtitleLabel)
    }
    
    private let titleLabel: PaddingLabel = build {
        $0.font = BaseFont.bold.withSize(32)
        $0.textColor = BaseColor.base50
        $0.text = "1 978 568 123 124,15 ₸"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.textAlignment = .center
        $0.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private let subtitleLabel: UILabel = build {
        $0.font = BaseFont.medium.withSize(13)
        $0.textColor = BaseColor.base100.withAlphaComponent(0.8)
        $0.text = "128 498,46 ₸  |  1 690,7 $  |  500,78 €  |  10 000,19 ₽"
        $0.textAlignment = .center
    }
    
    private let bottomLabel: PaddingLabel = build {
        $0.text = "Цифровая дебетовая"
        $0.textAlignment = .center
        $0.textColor = BaseColor.base100.withAlphaComponent(0.8)
        $0.font = BaseFont.medium.withSize(13)
        $0.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    private lazy var themeStackView: UIStackView = build(UIStackView(arrangedSubviews: [themeTitleLable, themeCollectionView])) {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 32
    }

    private let themeTitleLable: PaddingLabel = build {
        $0.font = BaseFont.semibold.withSize(18)
        $0.textColor = BaseColor.base50
        $0.textAlignment = .center
        $0.text = "Выберите тему"
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }

    private let saveTehemeButton: UIButton = build {
        $0.backgroundColor = BaseColor.base50
        $0.setTitleColor(BaseColor.base800, for: .normal)
        $0.layer.cornerRadius = 16
        $0.titleLabel?.font = BaseFont.semibold.withSize(18)
        $0.setTitle("Сохранить", for: .normal)
    }

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = CGFloat(minimumSpacing)
        $0.minimumInteritemSpacing = 0
    }

    private lazy var collectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout)) {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(BaseCollectionContainerCell<PDActionButtonView>.self)
        
        $0.dataSource = self
        $0.delegate = self
    }

    private lazy var themeLayout: UICollectionViewFlowLayout = build {
        let height = (UIScreen.main.bounds.width - 134)/4
        $0.itemSize = CGSize(width: height, height: height)
        $0.sectionInset = .zero
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = CGFloat(themeMinimumSpacing)
        $0.minimumInteritemSpacing = 0
    }

    private lazy var themeCollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: themeLayout))  {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(BaseCollectionContainerCell<PDThemeView>.self)

        $0.dataSource = self
        $0.delegate = self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()

        saveTehemeButton.addTarget(self, action: #selector(saveTheme), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }

    @objc private func saveTheme() {
        saveThemeAction?()
    }

    private func configureSubviews() {

        layer.insertSublayer(gradientLayer, at: 0)

        addSubview(stackView)
        addSubview(themeStackView)
        addSubview(saveTehemeButton)
    
        var layoutConstraints = [NSLayoutConstraint]()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints +=  [
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.heightAnchor.constraint(equalToConstant: 88)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.heightAnchor.constraint(equalToConstant: 32)
        ]
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            subtitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ]

        themeStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints +=  [
            themeStackView.leftAnchor.constraint(equalTo: leftAnchor),
            themeStackView.rightAnchor.constraint(equalTo: rightAnchor),
            themeStackView.bottomAnchor.constraint(equalTo: saveTehemeButton.topAnchor, constant: -48),
        ]

        themeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints +=  [
            themeCollectionView.heightAnchor.constraint(equalToConstant: 56)
        ]

        saveTehemeButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints +=  [
            saveTehemeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            saveTehemeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            saveTehemeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -58),
            saveTehemeButton.heightAnchor.constraint(equalToConstant: 52),
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func configure(type: PDBCardType, items: [PDActionViewModel], selectedColor: GradientColor) {
        self.items = items
        self.selectedColor = selectedColor
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48)/3, height: 88)
        gradientLayer.colors = selectedColor.gradientColors.map { $0.cgColor }
        collectionView.reloadData()
        themeCollectionView.reloadData()
    }
}

extension PDBCardsView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == themeCollectionView {
            return gradientColors.count
        }
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == themeCollectionView {
            let cell: BaseCollectionContainerCell<PDThemeView> = collectionView.dequeueReusableCell(for: indexPath)
            let isSelected = selectedColor == gradientColors[indexPath.row]
            cell.innerView.configure(gradientColors: gradientColors[indexPath.row].gradientColors, isSelected: isSelected)
            return cell
        }

        let cell: BaseCollectionContainerCell<PDActionButtonView> = collectionView.dequeueReusableCell(for: indexPath)
        let item = items[safe: indexPath.row]
        cell.innerView.titleLabel.text = item?.title
        cell.innerView.imageView.image = item?.image.uiImage
        cell.addCorner()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let type: CardCollectionType = collectionView == themeCollectionView ? .theme : .action
        delegate?.didSelectItem(type: type, at: indexPath)
    }
}
