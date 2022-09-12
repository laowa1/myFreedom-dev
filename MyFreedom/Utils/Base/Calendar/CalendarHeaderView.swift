//
//  CalendarHeaderView.swift
//  MyFreedom
//
//  Created by m1pro on 16.06.2022.
//

import UIKit

class CalendarHeaderView: UICollectionReusableView {

    private let titleLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var dayTitles: [String] {
        var calendar = Calendar.current
        calendar.locale = locale
        var weekdays = calendar.shortWeekdaySymbols
        weekdays.append(weekdays[0])
        weekdays.remove(at: 0)
        return weekdays
    }

    var locale = Locale(identifier: "ru_RU") {
        didSet { collectionView.reloadData() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(collectionView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ]

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: 36)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        backgroundColor = BaseColor.base50
        isUserInteractionEnabled = false

        titleLabel.font = BaseFont.medium
        titleLabel.textAlignment = .left
        titleLabel.textColor = BaseColor.base900

        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
    }

    private func setActions() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarDayCell.self)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension CalendarHeaderView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 7, height: 36)
    }
}

extension CalendarHeaderView: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return dayTitles.count
    }
}

extension CalendarHeaderView: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: CalendarDayCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.title = dayTitles[indexPath.item].uppercased()
        cell.font = BaseFont.medium.withSize(13)
        return cell
    }
}
