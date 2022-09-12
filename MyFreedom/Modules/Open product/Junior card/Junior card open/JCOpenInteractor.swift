//
//  JCOpenInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 04.07.2022.
//

import UIKit
import Lottie

protocol JCOpenInteractorInput {
    func getSectionsCount() -> Int
    func getCountBy(section: Int) -> Int
    func getElementBy(id: IndexPath) -> JCOpenFieldItemElement
    func getSectiontBy(section: Int) -> JCOpenTable.Section
    func didSelectItem(at index: Int)
    func getSelectedValue(item: JCOpenFieldItemType) -> String
    func didEnter(phoneNumber: String)
    func continueTapped()
    func openSuccessPage()
    func createElements()
}

class JCOpenInteractor: JCOpenInteractorInput {

    var view: JCOpenViewInput?
    private var commonStore: CommonStore

    private var sections = [JCOpenTable.Section]()
    private var juniors = [SingleSelectionItem]()

    private var juniorName = ""
    private var juniorNumber = ""
    private var currentLevel: Int = 0
    private let maxLevel: Int = 2

    init(view: JCOpenViewInput, commonStore: CommonStore) {
        self.commonStore = commonStore
        self.view = view
    }

    private func checkCorrectData() {
        view?.nextButton(hide: (juniorName == "" || juniorNumber == ""))
    }

    private func getSingleSelectionVM() -> SingleSelectionViewModel {

        return SingleSelectionViewModel(title: "Выберите ребенка",
                                        currentLevel: currentLevel,
                                        maxLevel: maxLevel,
                                        elements: juniors,
                                        delegate: self,
                                        previousModule: self.view)
    }

    private func getEPContactPickerVM() -> EPContactsPickerViewModel {

        return EPContactsPickerViewModel(title: "Номер телефона ребенка",
                                         delegate: self,
                                         currentLevel: currentLevel,
                                         maxLevel: maxLevel,
                                         nextModule: self.view)

    }

    private func update() {
        checkCorrectData()
        view?.reload()
    }

    func getSectionsCount() -> Int {
        sections.count
    }

    func getCountBy(section: Int) -> Int {
        sections[section].elements.count
    }

    func getElementBy(id: IndexPath) -> JCOpenFieldItemElement {
        sections[id.section].elements[id.row]
    }

    func getSectiontBy(section: Int) -> JCOpenTable.Section {
        sections[section]
    }

    func getSelectedValue(item: JCOpenFieldItemType) -> String {
        switch item {
        case .name:
            return juniorName
        case .phoneNumber:
            return juniorNumber
        }
    }

    func openSuccessPage() {

        let titleText = NSMutableAttributedString(string: "Вы успешно открыли ", attributes: [
            .font: BaseFont.semibold.withSize(28),
            .foregroundColor: BaseColor.base900
        ])

        titleText.append(NSAttributedString(string: "Детскую карту", attributes: [
            .font: BaseFont.semibold.withSize(28),
            .foregroundColor: BaseColor.green500
        ]))

        let model = InformPUViewModel(
            titleText: titleText,
            subtitleText: "Пользуйтесь депозитом с нашими удобными условиями и приятными бонусами",
            image: .JCSuccess,
            buttons:
                [ .init(type: .confirm, title: "Перейти на страницу Детской карты", isGreen: true),
                .init(type: .cancel, title: "Вернуться на Главную", isGreen: false)],
            hiddenBack: true,
            id: UUID()
        )

        view?.routeToInformConfirmIdentity(model: model, delegate: self)
    }

    func didSelectItem(at index: Int) {
        switch index {
        case 0:
            let module = SingleSelectionRouter<UUID>(commonStore: commonStore, viewModel: getSingleSelectionVM())
            let nextModule = EPContactsPickerRouter(commonStore: commonStore, viewModel: getEPContactPickerVM())

            nextModule.viewModel.currentLevel = 1
            module.viewModel.nextModule = nextModule.build()

            view?.routeToChooseChild(module: module.build())
        case 1:
            let module = EPContactsPickerRouter(commonStore: commonStore, viewModel: getEPContactPickerVM()).build()
            view?.routeToEPContacts(module: module)
        default: break
        }
    }

    func continueTapped() {
        view?.routeToOtp(phone: juniorNumber)
    }

    func createElements() {

        sections += [
            .init(id: .children, elements: [
                .init(image: BaseImage.chevronBottom.uiImage, title: "Выберите ребенка", fieldType: .name, description: "Выберите одного ребенка"),
                .init(image: BaseImage.contacts.uiImage, title: "Номер телефона ребенка", fieldType: .phoneNumber, description: "+7")
            ])
        ]

        juniors +=  [
            .init(title: "Маркорий Андрей Владимирович", isSelected: true),
            .init(title: "Маркорий Александр Владимирович"),
            .init(title: "Маркорий Александр Владимирович")
        ]

        update()
    }
}

extension JCOpenInteractor: SingleSelectionDelegate, EPPickerDelegate {

    func didSelect<ID>(at indexPath: IndexPath, for id: ID) {

        for (index, item) in juniors.enumerated() {
            juniors[index].isSelected = false
            if index == indexPath.row {
                juniors[index].isSelected = true
                currentLevel = 1
                juniorName = item.title
            }
        }

        update()
    }

    func didEnter(phoneNumber: String) {
        currentLevel = 1
        juniorNumber = phoneNumber
    }

    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact) {
        juniorNumber = contact.phoneNumbers[0].phoneNumber
        currentLevel = 1
        update()
    }
}

extension JCOpenInteractor: InformPUButtonDelegate {

    func buttonPressed(type: InformPUButtonType, id: UUID) {
        view?.popToRoot()
    }
}
