//
//  CalendarViewController.swift
//  MyFreedom
//
//  Created by m1pro on 16.06.2022.
//

import UIKit

protocol CalendarDelegate: AnyObject {

    func didSelect(fromDate: Date?, toDate: Date?)
}

class CalendarViewController: BaseViewController {
    
    override var baseModalPresentationStyle: UIModalPresentationStyle { .formSheet }

    private var firstTimeMax = 0
    private var headerView = BackdropHeaderView()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let button = UIButton(type: .system)

    public var selectableDaysCount = Calendar.current.range(of: .day, in: .year, for: Date())?.count

    public var minDate = Calendar.current.date(byAdding: .year, value: -4, to: Date()) {
        didSet { createItems() }
    }
    
    public var headerTitle: String = ""
    public var headerRightButtonTitle: String?

    public var canSelectPeriod = false

    public var locale = Locale(identifier: "ru_RU") {
        didSet { collectionView.reloadData() }
    }
    
    private var buttonTitle: String? {
        get { button.currentTitle }
        set {
            button.isHidden = newValue?.isEmpty == true
            button.setTitle(newValue, for: .normal)
        }
    }

    private var headerItems: [CalendarHeaderItem] = []

    private var firstSelectedIndexPath: IndexPath? {
        didSet {
            generateButtonTitle()
        }
    }
    private var secondSelectedIndexPath: IndexPath? {
        didSet {
            generateButtonTitle()
        }
    }

    public weak var delegate: CalendarDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
        createItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstTimeMax < 2  {
            firstTimeMax += 1
            let offset = collectionView.contentSize.height - collectionView.bounds.height + 24
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
        }
    }

    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(button)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 64)
        ]

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        button.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -24),
            button.heightAnchor.constraint(equalToConstant: 45)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.base100

        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 14
        
        collectionView.layer.cornerRadius = 16
        collectionView.backgroundColor = BaseColor.base50
        collectionView.allowsMultipleSelection = true

        button.backgroundColor = BaseColor.green500
        button.setTitleColor(BaseColor.base50, for: .normal)
        button.titleLabel?.font = BaseFont.semibold.withSize(18)
        button.layer.cornerRadius = 8
        button.isHidden = true
        
        headerView.configure(
            title: headerTitle,
            buttonTitle: headerRightButtonTitle) { [weak self] in
                guard let self = self else { return }
                self.firstSelectedIndexPath = nil
                self.secondSelectedIndexPath = nil
                self.collectionView.reloadData()
            }
    }

    private func setActions() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            CalendarHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        collectionView.register(CalendarDayCell.self)

        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    private func createItems() {
        guard let minDate = minDate else { return }
        headerItems = []

        let calendar = Calendar.current

        let minDay = calendar.component(.day, from: minDate)
        let minYear = calendar.component(.year, from: minDate)

        let currentDate = Date()
        let currentDay = calendar.component(.day, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)

        for year in minYear...currentYear {
            let minMonth = year == minYear ? calendar.component(.month, from: minDate) : 1
            let maxMonth = year == currentYear ? currentMonth : 12

            for month in minMonth...maxMonth {
                let dateComponent = DateComponents(year: year, month: month, day: 1)
                guard let date = calendar.date(from: dateComponent),
                      let range = calendar.range(of: .day, in: .month, for: date) else { continue }

                let weekDay = calendar.component(.weekday, from: date) - 1
                let originalWeekDay = weekDay > 0 ? weekDay : weekDay + 7

                let daysCount = range.count
                var dayItems = Array(1...daysCount).map { DayItem(day: $0, isEnabled: true) }

                // 0 means empty day
                for _ in 1..<originalWeekDay {
                    dayItems.insert(DayItem(day: 0, isEnabled: false), at: 0)
                }

                for (index, item) in dayItems.enumerated() {
                    if (year == currentYear && month == currentMonth && item.day > currentDay) ||
                        (year == minYear && month == minMonth && item.day < minDay) {
                        dayItems[index] = DayItem(day: item.day, isEnabled: false)
                    }
                }

                let dateFormatter = DateFormatter()
                dateFormatter.locale = locale
                dateFormatter.dateFormat = "LLLL yyyy"

                let title = dateFormatter.string(from: date).capitalized
                let item = CalendarHeaderItem(title: title, year: year, month: month, dayItems: dayItems)
                headerItems.append(item)
            }
        }

        collectionView.reloadData()
    }
    
    private func generateButtonTitle() {
        var text = ""
        if let firstIndexPath = firstSelectedIndexPath,
           let month = headerItems[firstIndexPath.section].title.split(separator: " ").first {
            button.isHidden = false
            let day = headerItems[firstIndexPath.section].dayItems[firstIndexPath.item].day
            text = text + day.description + " " + month
        }
        
        if let secondIndexPath = secondSelectedIndexPath,
           let month = headerItems[secondIndexPath.section].title.split(separator: " ").first {
            button.isHidden = false
            let day = headerItems[secondIndexPath.section].dayItems[secondIndexPath.item].day
            text = text + " - " + day.description + " " + month
        }
        
        buttonTitle = text
    }

    @objc private func buttonAction() {
        var fromDate: Date?
        var toDate: Date?

        if let firstIndexPath = firstSelectedIndexPath {
            let year = headerItems[firstIndexPath.section].year
            let month = headerItems[firstIndexPath.section].month
            let day = headerItems[firstIndexPath.section].dayItems[firstIndexPath.item].day
            var dateComponents = DateComponents()

            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day

            fromDate = Calendar.current.date(from: dateComponents)
        }

        if let secondIndexPath = secondSelectedIndexPath {
            let year = headerItems[secondIndexPath.section].year
            let month = headerItems[secondIndexPath.section].month
            let day = headerItems[secondIndexPath.section].dayItems[secondIndexPath.item].day
            var dateComponents = DateComponents()

            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day

            toDate = Calendar.current.date(from: dateComponents)
        }

        dismiss(animated: true) { [weak self] in
            self?.delegate?.didSelect(fromDate: fromDate, toDate: toDate)
            
        }
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 7, height: 40)
    }
}

extension CalendarViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let firstIndexPath = firstSelectedIndexPath,
           let selectableDaysCount = selectableDaysCount,
           secondSelectedIndexPath == nil {
            let startIndexPath = firstIndexPath > indexPath ? indexPath : firstIndexPath
            let endIndexPath = firstIndexPath > indexPath ? firstIndexPath : indexPath

            var numberOfItems = 0

            for section in startIndexPath.section...endIndexPath.section {
                let dayItems = headerItems[section].dayItems

                if section == startIndexPath.section {
                    numberOfItems += dayItems[startIndexPath.item...dayItems.count - 1].filter { $0.day != 0 }.count
                } else if section == endIndexPath.section {
                    numberOfItems += dayItems[0...endIndexPath.item].filter { $0.day != 0 }.count
                } else {
                    numberOfItems += dayItems.filter { $0.day != 0 }.count
                }
            }

            return numberOfItems <= selectableDaysCount
        }

        return true
    }

    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return true }

        return !selectedIndexPaths.contains(indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard canSelectPeriod else {
            if let firstIndexPath = firstSelectedIndexPath {
                firstSelectedIndexPath = nil
                collectionView.deselectItem(at: firstIndexPath, animated: true)
            }
            firstSelectedIndexPath = indexPath
            return
        }

        if let firstIndexPath = firstSelectedIndexPath, let secondIndexPath = secondSelectedIndexPath {
            firstSelectedIndexPath = nil
            secondSelectedIndexPath = nil
            collectionView.deselectItem(at: firstIndexPath, animated: true)
            collectionView.deselectItem(at: secondIndexPath, animated: true)
        }

        if firstSelectedIndexPath == nil {
            firstSelectedIndexPath = indexPath
        } else if secondSelectedIndexPath == nil {
            secondSelectedIndexPath = indexPath
        }

        if let firstIndexPath = firstSelectedIndexPath, let secondIndexPath = secondSelectedIndexPath {
            if firstIndexPath > secondIndexPath {
                firstSelectedIndexPath = secondIndexPath
                secondSelectedIndexPath = firstIndexPath
            }
        }

        collectionView.reloadData()
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let headerView: CalendarHeaderView =
            collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
        headerView.title = headerItems[indexPath.section].title
        headerView.locale = locale
        return headerView
    }
}

extension CalendarViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int { headerItems.count }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerItems[section].dayItems.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = headerItems[indexPath.section].dayItems[indexPath.item]
        let cell: CalendarDayCell = collectionView.dequeueReusableCell(for: indexPath)

        cell.title = item.day == 0 ? nil : item.day.description
        cell.isEnabled = item.isEnabled
        cell.isDaySelected = firstSelectedIndexPath == indexPath || secondSelectedIndexPath == indexPath

        if firstSelectedIndexPath == indexPath, secondSelectedIndexPath != nil {
            cell.coverMode = .right
        } else if secondSelectedIndexPath == indexPath, firstSelectedIndexPath != nil {
            cell.coverMode = .left
        } else {
            if let firstIndexPath = firstSelectedIndexPath, let secondIndexPath = secondSelectedIndexPath {
                cell.coverMode = indexPath > firstIndexPath && indexPath < secondIndexPath ? .full : .none
            }
        }

        return cell
    }
}

extension CalendarViewController: BaseDrawerContentViewControllerProtocol {

    public var contentViewHeight: CGFloat { view.frame.height }
}
