//
//  FCReferencesInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 15.06.2022.
//

import UIKit.UIUserNotificationSettings

class FCReferencesInteractor {

    private unowned var view: FCReferencesViewInput
    private var sections: [FCReferenceTable.Section] = []
    private let calendar = Calendar.current
    private var fromDate: Date? = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())
    private var toDate: Date? = Date()

    init(view: FCReferencesViewInput) {
        self.view = view
    }
    
    private func getIndexPath(by identifier: FCReferenceItemFiledType) -> IndexPath? {
        for (section, element) in sections.enumerated() {
            if let row = element.elements.firstIndex(where: { $0.filedType == identifier }) {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }
    
    private func setPeriod() {
        guard let fromDate = fromDate,
              let toDate = toDate,
              let languageCode: String = KeyValueStore().getValue(for: .languageCode),
              let language = Language(code: languageCode) else { return }

        let currentYear = calendar.component(.year, from: Date())
        let fromYear = calendar.component(.year, from: fromDate)
        let toYear = calendar.component(.year, from: toDate)
        let dMMMM: Date.Format = .dMMMM(separator: " ")
        let dMMMMyyyy: Date.Format = .dMMMMyyyy(separator: " ")

        let periodFrom = currentYear == fromYear ?
            fromDate.string(withFormat: dMMMM, locale: language.locale) :
            fromDate.string(withFormat: dMMMMyyyy, locale: language.locale)
        let periodTo = currentYear == toYear ?
            toDate.string(withFormat: dMMMM, locale: language.locale) :
            toDate.string(withFormat: dMMMMyyyy, locale: language.locale)

        guard let indexPath = getIndexPath(by: .selectPeriod) else { return }
        
        sections[indexPath.section].elements[indexPath.row].subtitle = periodFrom + " - " + periodTo
        view.update(at: indexPath, selected: true)
    }
}

extension FCReferencesInteractor {
    
    func createElements() {
        sections += [
            .init(id: .reference, title: "Выберите вид справки", elements: [
                .init(image: BaseImage.pdReferences.uiImage, title: "О наличии счета", subtitle: "Подходит для бухгалтерии", filedType: .reference),
                .init(image: BaseImage.pdReferences.uiImage, title: "О доступном остатке", subtitle: "Подходит для посольства, налоговых органов", filedType: .reference),
            ]),

            .init(id: .language, title: "Язык справки", elements: [
                .init(title: "На русском", filedType: .language),
                .init(title: "Қазақша", filedType: .language),
                .init(title: "English", filedType: .language)
            ]),

            .init(id: .period, title: "За период", elements: [
                .init(title: "Месяц", subtitle: "22 мар - 22 апр", filedType: .period),
                .init(title: "Три месяца", subtitle: "22 янв - 22 апр", filedType: .period),
                .init(title: "Полгода", subtitle: "22 окт ‘21 - 22 апр", filedType: .period),
                .init(title: "Год", subtitle: "22 апр ‘21 - 22 апр", filedType: .period),
                .init(title: "Выбрать период", filedType: .selectPeriod)
            ])
        ]

        view.reloadData()
    }
}

extension FCReferencesInteractor: FCReferencesInteractorInput {
    
    func getItemBy(indexPath: IndexPath) -> FCReferenceFieldItemElement {
        sections[indexPath.section].elements[indexPath.row]
    }

    func getItemCountIn(section: Int) -> Int {
        sections[section].elements.count
    }

    func getSectionCount() -> Int {
        sections.count
    }

    func getSectiontBy(section: Int) -> FCReferenceTable.Section {
        sections[section]
    }

    func didSelectItem(at indexPath: IndexPath) {
        sections[indexPath.section].selectedIndex = indexPath.row
        
        let type = getItemBy(indexPath: indexPath).filedType
        if type == .selectPeriod {
            let currentDate = Date()
            guard let minDate = calendar.date(byAdding: .year, value: -4, to: currentDate),
                  let days = calendar.range(of: .day, in: .year, for: currentDate) else { return }
            view.routeToCalendarPage(minDate: minDate, selectableDaysCount: days.count)
        }
    }
    
    func didSelect(fromDate: Date?, toDate: Date?) {
        guard let fromDate = fromDate, let toDate = toDate else { return }
        self.fromDate = fromDate
        self.toDate = toDate
        setPeriod()
    }
}
