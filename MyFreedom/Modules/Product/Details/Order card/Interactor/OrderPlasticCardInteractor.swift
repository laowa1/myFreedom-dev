//
//  OrderCardInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 16.06.2022.
//

import Foundation

class OrderPlasticCardInteractor {

    private var view: OrderPlasticCardViewInput?
    private var orderType: OrderPlasticCardType?
    private var sections = [OrderPalsticCardTable.Section]()
    private lazy var model = generateModel()

    init(view: OrderPlasticCardViewInput, orderType: OrderPlasticCardType) {
        self.view = view
    }
    
    private func generateModel() -> InputLevelModel {
        let streetModel = CurrentInputLevelModel(title: "Улица и № дома", placeHolder: "Например, Абая 12", id: .street)
        let officeModel = CurrentInputLevelModel(title: "Квартира/Офис", placeHolder: "Например, 12", keyboardType: .numberPad, id: .office)
        let entranceModel = CurrentInputLevelModel(title: "Подъезд", placeHolder: "Например, 1", keyboardType: .numberPad, id: .entrance)
        return InputLevelModel(levels: [streetModel, officeModel, entranceModel], currentLevelIndex: -1)
    }
    
    private func getIndexPath(by identifier: OrderPlasticCardItemId) -> IndexPath? {
        for (section, element) in sections.enumerated() {
            if let row = element.elements.firstIndex(where: { $0.id == identifier }) {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }
}

extension OrderPlasticCardInteractor: OrderPlasticCardInteractorInput {

    func createElements() {

        sections = [
            .init(id: .info, elements: [
                .init(fieldType: .info, description:
                """
                • Курьер доставит пластиковую карту в течение 2 рабочих дней.
                • В целях безопасности, чтобы выдать карту, курьер должен вас сфотографировать.
                • Цифровая карта будет доступна сразу после открытия.
                """, id: .info),
                .init(fieldType: .info, description: "Адрес доставки", id: .info)
            ]),
            .init(id: .address, title: "Адрес доставки", elements: [
                .init(fieldType: .city, description: "Алматы", title: "Город", icon: BaseImage.chevronRight.uiImage, id: .city),
                .init(fieldType: .street, description: "Например, Абая 12", title: "Улица и № дома", id: .street),
                .init(fieldType: .flat(flat: "Квартира/Офис", entrance: "Подъезд"), description: "№", id: .flatEntrance)
            ])
        ]

        view?.reload()
    }

    func getItemBy(indexPath: IndexPath) -> OrderPalsticCardElement {
        sections[indexPath.section].elements[indexPath.row]
    }

    func getItemCountIn(section: Int) -> Int {
        sections[section].elements.count
    }

    func getSectionCount() -> Int {
        sections.count
    }

    func getSectiontBy(section: Int) -> OrderPalsticCardTable.Section {
        sections[section]
    }

    func didSelectItem(at indexPath: IndexPath) {
        switch getItemBy(indexPath: indexPath).fieldType {
        case .city:
            print("Show dropdown")
        default: return
        }
    }
    
    func getModel(currentLevelIndex: Int) -> InputLevelModel {
        model.currentLevelIndex = currentLevelIndex
        return model
    }
    
    func updateValues() {
        if let streetIndexPath = getIndexPath(by: .street) {
            sections[streetIndexPath.section].elements[streetIndexPath.row].text = model.levels.first(where: { $0.id == .street })?.value
            view?.reloadCell(at: streetIndexPath)
        }
        
        if let flatIndexPath = getIndexPath(by: .flatEntrance) {
            sections[flatIndexPath.section].elements[flatIndexPath.row].fieldType = .flat(
                flat: "Квартира/Офис",
                flatValue: model.levels.first(where: { $0.id == .office })?.value,
                entrance: "Подъезд",
                entranceValue: model.levels.first(where: { $0.id == .entrance })?.value
            )
            view?.reloadCell(at: flatIndexPath)
        }
        
    }
}
