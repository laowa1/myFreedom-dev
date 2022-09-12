//
//  DepositAwardsIntreactor.swift
//  MyFreedom
//
//  Created by &&TairoV on 23.06.2022.
//

import UIKit

class DepositRewardsInteractor: DepositRewardsInteractorInput {

    private var view: DepositRewardsViewInput?
    private var sections = [DepositRewardsTable.Section]()
    private var selectedIndex = 0
    private let calendar = Calendar.current
    private var fromDate: Date? = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())
    private var toDate: Date? = Date()

    private var periodItems = [
        PeriodSelectionCell(title: "За все время", description: "октябрь ‘20 - апрель 22 "),
        PeriodSelectionCell(title: "За 3 месяца", description: "апрель - июнь"),
        PeriodSelectionCell(title: "За полгода", description: "Январь - июнь"),
        PeriodSelectionCell(title: "За один год", description: "июнь ‘21 - июнь 22 "),
        PeriodSelectionCell(title: "Выбрать период", accessoryImage: BaseImage.chevronRight.uiImage)
    ]

    private func getIndexPath(by identifier: DepositRewardsFieldType) -> IndexPath? {
        for (section, element) in sections.enumerated() {
            if let row = element.elements.firstIndex(where: { $0.fieldType == identifier }) {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }

    private func setPeriod() {
//        guard let fromDate = fromDate,
//              let toDate = toDate,
//              let languageCode: String = KeyValueStore().getValue(for: .languageCode),
//              let language = Language(code: languageCode) else { return }
//
//        let currentYear = calendar.component(.year, from: Date())
//        let fromYear = calendar.component(.year, from: fromDate)
//        let toYear = calendar.component(.year, from: toDate)
//        let dMMMM: Date.Format = .dMMMM(separator: " ")
//        let dMMMMyyyy: Date.Format = .dMMMMyyyy(separator: " ")
//
//        let periodFrom = currentYear == fromYear ?
//            fromDate.string(withFormat: dMMMM, locale: language.locale) :
//            fromDate.string(withFormat: dMMMMyyyy, locale: language.locale)
//        let periodTo = currentYear == toYear ?
//            toDate.string(withFormat: dMMMM, locale: language.locale) :
//            toDate.string(withFormat: dMMMMyyyy, locale: language.locale)
//
//        guard let indexPath = getIndexPath(by: .total) else { return }
//        TO-DO: update text
//        sections[indexPath.section].elements[indexPath.row].subtitle = periodFrom + " - " + periodTo
//        view.update(at: indexPath, selected: true)
    }

    init(view: DepositRewardsViewInput) {
        self.view = view
    }

    func createElements() {

        sections += [
            .init(id: .period, elements: [
                .init(fieldType: .total, precent: "10,5% ", totalReward: "+12 232,80 $")
            ]),

            .init(id: .period, title: "2022", elements: [
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Июнь"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Май"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Апрель"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Март"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Февраль"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Январь")
            ]),

            .init(id: .period, title: "2021", elements: [
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Декабрь"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Ноябрь"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Октябрь"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Сентябрь"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Август"),
                .init(fieldType: .period, description: "+ 1 200,00 ₸", title: "Июль")
            ])
        ]

        view?.reload()
    }

    func getCountBy(section: Int) -> Int {
        sections[section].elements.count
    }

    func getSectionsCount() -> Int {
        sections.count
    }

    func getSectiontBy(section: Int) -> DepositRewardsTable.Section {
        sections[section]
    }

    func getElementBy(id: IndexPath) -> DepositRewardsFieldElement {
        sections[id.section].elements[id.row]
    }

    func showPeriodSelolection() {
        let module = BottomSheetPickerViewController<PeriodCell>()
        let viewModel = BottomSheetPickerViewModel(
            title: "За период".localized,
            id: UUID(),
            selectedIndex: selectedIndex,
            items: periodItems,
            delegate: self
        )
        module.presenter = BottomSheetPresenter(view: module, viewModel: viewModel)

        view?.showPeriodSelection(module: module)
    }
}

extension DepositRewardsInteractor: BottomSheetPickerViewDelegate {

    func didSelect(index: Int, id: UUID) {
        selectedIndex = index
        if index == 3 {
            let currentDate = Date()
            guard let minDate = calendar.date(byAdding: .year, value: -4, to: currentDate),
                  let days = calendar.range(of: .day, in: .year, for: currentDate) else { return }
            view?.routeToCalendarPage(minDate: minDate, selectableDaysCount: days.count)
        }
    }

    func didSelect(fromDate: Date?, toDate: Date?) {
        guard let fromDate = fromDate, let toDate = toDate else { return }
        self.fromDate = fromDate
        self.toDate = toDate
        setPeriod()
    }
}
