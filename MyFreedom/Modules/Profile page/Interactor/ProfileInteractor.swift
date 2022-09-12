//
//  ProfileInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 06.05.2022.
//

import UIKit.UIUserNotificationSettings

class ProfileInteractor {
    
    private unowned var view: ProfileViewInput
    private unowned let logger: BaseLogger
    private let geoManager: GeopositionManager
    private let biometric = Biometric()
    
    private var sections: [ProfileTable.Section] = []
    private let keyValueStore = KeyValueStore()
    
    private var languageListItems = [
        LanguagePickerPickerItem(title: "Русский"),
        LanguagePickerPickerItem(title: "Қазақша"),
        LanguagePickerPickerItem(title: "English")
    ]
    private var themeListItems = [
        CollectionPickerPickerItem(title: "Светлое".localized, image: .themeWhite),
        CollectionPickerPickerItem(title: "Чеп черная".localized, image: .themeBlack),
        CollectionPickerPickerItem(title: "Системное".localized, image: .themeSystem)
    ]
    private var iconsListItems = [
        CollectionPickerPickerItem(title: "Синий".localized, description: "AppIcon-2", image: .iconBlue),
        CollectionPickerPickerItem(title: "Красный".localized, description: "AppIcon-1", image: .iconRed),
        CollectionPickerPickerItem(title: "Дефолтная".localized, description: nil, image: .iconDefault)
    ]
    
    private let languageListId = UUID()
    private let themeListId = UUID()
    private let iconListId = UUID()
    
    private var selectedLanguageTitle: String? { languageListItems.first(where: { $0.isSelected })?.title }
    private var selectedThemeTitle: String? { themeListItems.first(where: { $0.isSelected })?.title }
    private var selectedIconTitle: String? { iconsListItems.first(where: { $0.isSelected })?.title }
    
    init(view: ProfileViewInput, logger: BaseLogger) {
        self.view = view
        self.logger = logger
        self.geoManager = GeopositionManager(logger: logger)
        self.geoManager.showLocationSettings = { [weak self] in
            guard let self = self else { return }
            self.showSettingsAlert(
                message: "Для определения Вашей текущей геопозиции необходимо разрешить доступ в настройках. Перейти в настройки?"
            )
        }
        
        if let languageCode: String = keyValueStore.getValue(for: .languageCode),
           let language = Language(code: languageCode) {
            switch language {
            case .ru: languageListItems[0].isSelected = true
            case .kk: languageListItems[1].isSelected = true
            case .en: languageListItems[2].isSelected = true
            }
        }
        
        if let rawValue: String = keyValueStore.getValue(for: .theme),
           let theme = Theme(rawValue: rawValue) {
            switch theme {
            case .light: themeListItems[0].isSelected = true
            case .dark: themeListItems[1].isSelected = true
            case .system: themeListItems[2].isSelected = true
            }
        }
    }
    
    private func showChangeLanguage() {
        let module = BottomSheetPickerViewController<LanguageCell>()
        let viewModel = BottomSheetPickerViewModel(
            title: "Язык приложения".localized,
            id: languageListId,
            selectedIndex: languageListItems.firstIndex(where: { $0.isSelected }) ?? -1,
            items: languageListItems,
            delegate: self
        )
        module.presenter = BottomSheetPresenter(view: module, viewModel: viewModel)
        
        view.presentDocumentList(module: module)
    }
    
    private func showChangeTheme() {
        let module = CollectionPickerViewController<CollectionPickerItemCell>()
        let viewModel = BottomSheetPickerViewModel(
            title: "Оформление",
            id: themeListId,
            selectedIndex: -1,
            items: themeListItems,
            delegate: self
        )
        module.presenter = BottomSheetPresenter(view: module, viewModel: viewModel)
        
        view.presentDocumentList(module: module)
    }
    
    private func showChangeIcon() {
        let module = CollectionPickerViewController<ChangeIconItemCell>()
        let viewModel = BottomSheetPickerViewModel(
            title: "Иконка",
            id: iconListId,
            selectedIndex: -1,
            items: iconsListItems,
            delegate: self
        )
        module.presenter = BottomSheetPresenter(view: module, viewModel: viewModel)
        
        view.presentDocumentList(module: module)
    }
    
    private func getEnable(key: KeyValueStore.Key) -> Bool {
        let enable: Bool? = KeyValueStore().getValue(for: key)
        return enable ?? false
    }
    
    private func showSettingsAlert(message: String) {
        self.view.showAlert(
            title: "Внимание",
            message: message,
            first: .init(title: "Отмена", style: .cancel, handler: nil),
            second: .init(title: "Да", style: .default, handler: { [weak self] _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
        )
    }
    
    private func getIndexPath(by identifier: ProfileItemId) -> IndexPath? {
        for (section, element) in sections.enumerated() {
            if let row = element.elements.firstIndex(where: { $0.id == identifier }) {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }
    
    private func setAppIcon(_ named: String?) {
        UIApplication.shared.setAlternateIconName(named) { (err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("Done!")
            }
        }
    }
}

extension ProfileInteractor: ProfileInteractorInput {
    func getItemBy(indexPath: IndexPath) -> ProfileFieldItemElement<ProfileItemId>? {
        return sections[safe: indexPath.section]?.elements[safe: indexPath.row]
    }
    
    func getItemCountIn(section: Int) -> Int {
        return sections[section].elements.count
    }
    
    func getSectionCount() -> Int {
        return sections.count
    }
    
    func getSectiontBy(section: Int) -> ProfileTable.Section {
        return sections[section]
    }
    
    func createElements() {
        sections += [
            .init(id: .digitalDocuments, elements: [
                .init(id: .digitalDocuments, title: "", filedType: .digitalDocuments)
            ]),
            .init(id: .management, title: "Управление",
                  elements: [
                    .init(
                        id: .allOperations,
                        image: BaseImage.profile_clock.uiImage,
                        title: "Все операции",
                        filedType: .accessory
                    ),
                    .init(
                        id: .bonuses,
                        image: BaseImage.profile_bonuses.uiImage,
                        title: "Бонусы",
                        filedType: .accessory
                    ),
                    ProfileFieldItemElement(
                        id: .monthlyPayments,
                        image: BaseImage.profile_payment.uiImage,
                        title: "Ежемесячные платежи",
                        filedType: .accessory
                    )
                  ]
                 ),
            
                .init(id: .security, title: "Безопасность",
                      elements: [
                        ProfileFieldItemElement(
                            id: .changeNumber,
                            image: BaseImage.profile_phone.uiImage,
                            title: "Изменить номер",
                            caption: "8 7** *** 46 15",
                            filedType: .accessory
                        ),
                        ProfileFieldItemElement(
                            id: .addEmail,
                            image: BaseImage.profile_email.uiImage,
                            title: "Добавить email",
                            filedType: .accessory
                        ),
                        // TODO: logic for not biometric
                        ProfileFieldItemElement(
                            id: .loginWithFaceID,
                            image: BaseImage.profile_faceID.uiImage,
                            title: "Вход с \(biometric.biometricType.name)",
                            filedType: .switcher(isOn: getEnable(key: .useBiometryToUnlock))
                        ),
                        ProfileFieldItemElement(
                            id: .changeAccessCode,
                            image: BaseImage.profile_passcode.uiImage,
                            title: "Изменить код доступа",
                            filedType: .accessory
                        )
                      ]),
            
                .init(id: .settings, title: "Настройки",
                      elements: [
                        ProfileFieldItemElement(
                            id: .notifications,
                            image: BaseImage.profile_notification.uiImage,
                            title: "Уведомления",
                            filedType: .switcher(isOn: getEnable(key: .enableGeo))
                        ),
                        ProfileFieldItemElement(
                            id: .applicationLanguage,
                            image: BaseImage.profile_language.uiImage,
                            title: "Язык приложения".localized,
                            caption: selectedLanguageTitle,
                            filedType: .accessory
                        ),
                        ProfileFieldItemElement(
                            id: .geolocation,
                            image: BaseImage.profile_location.uiImage,
                            title: "Геолокация",
                            filedType: .switcher(isOn: getEnable(key: .enableGeo))
                        ),
                        ProfileFieldItemElement<ProfileItemId>(
                            id: .theme,
                            image: BaseImage.profile_decoration.uiImage,
                            title: "Оформление",
                            caption: selectedThemeTitle,
                            filedType: .accessory
                        ),
                        ProfileFieldItemElement<ProfileItemId>(
                            id: .icon,
                            image: BaseImage.profile_decoration.uiImage,
                            title: "Иконка",
                            caption: selectedIconTitle,
                            filedType: .accessory
                        )
                      ]),
            
                .init(id: .button, elements: [
                    ProfileFieldItemElement<ProfileItemId>(
                        id: .logout,
                        title: "Выйти из приложения",
                        filedType: .button
                    )
                ]),
        ]
    }
    
    func disablePasscodeUsage() {
        try? KeychainPasswordItem(
            service: KeychainConfiguration.serviceName,
            account: KeychainConfiguration.passcodeKey,
            accessGroup: KeychainConfiguration.accessGroup
        ).deleteItem()
        
        keyValueStore.removeValue(for: .usePasscodeToUnlock)
        keyValueStore.removeValue(for: .useBiometryToUnlock)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let id = getItemBy(indexPath: indexPath)?.id else { return }
        switch id {
        case .applicationLanguage:
            showChangeLanguage()
        case .theme:
            showChangeTheme()
        case .icon:
            showChangeIcon()
        case .changeAccessCode:
            view.routeToChangeAC(delegate: self as AccessCodeChangeDelegate)
        case .changeNumber:
            view.routeChangeNumber(delegate: self)
        case .addEmail:
            view.routeToAddEmail(delegate: self)
            
        default: break
        }
    }
    
    func switcher(isOn: Bool, at indexPath: IndexPath) {
        switch sections[indexPath.section].elements[indexPath.row].id {
        case .notifications:
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { [weak self] settings in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if(settings.authorizationStatus == .authorized) {
                        self.sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: isOn)
                        self.keyValueStore.set(value: isOn, for: .enablePush)
                        self.view.showAlertOnTop(
                            withMessage: isOn ? "Уведомления включены".localized : "Уведомления выключены".localized,
                            lottie: nil
                        )
                    } else {
                        self.sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: false)
                        self.showSettingsAlert(
                            message: "Для отправки пуша необходимо разрешить доступ в настройках. Перейти в настройки?"
                        )
                    }
                    
                    self.view.update(at: indexPath)
                }
            }
        case .loginWithFaceID:
            let biometricTypeName = biometric.biometricType.name
            if isOn {
                view.routeToEnterCurrentAC(type: biometricTypeName, delegate: self as AccessCodeConfirmFaceDelegate)
                view.update(at: indexPath)
            } else {
                view.showAlertOnTop(withMessage: "Вход в \(biometricTypeName) выключен".localized, lottie: nil)
                keyValueStore.set(value: isOn, for: .useBiometryToUnlock)
                sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: false)
                view.update(at: indexPath)
            }
        case .geolocation:
            if isOn {
                geoManager.getCurrentUserPosition { [weak self] lat, long in
                    guard let self = self else { return }
                    if lat == nil || long == nil {
                        self.sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: false)
                        self.geoManager.showLocationSettings?()
                        self.view.update(at: indexPath)
                        return
                    }
                    self.keyValueStore.set(value: true, for: .enableGeo)
                    self.sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: true)
                    self.view.showAlertOnTop(withMessage: "Геолокация включена".localized, lottie: nil)
                    self.view.update(at: indexPath)
                }
            } else {
                keyValueStore.set(value: false, for: .enableGeo)
                sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: isOn)
                view.showAlertOnTop(withMessage: "Геолокация выключена".localized, lottie: nil)
                view.update(at: indexPath)
            }
        default: break
        }
    }
}

extension ProfileInteractor: BottomSheetPickerViewDelegate {
    
    func didSelect(index: Int, id: UUID) {
        switch id {
        case languageListId:
            switch index {
            case 0: keyValueStore.set(value: Language.ru.code, for: .languageCode)
            case 1: keyValueStore.set(value: Language.kk.code, for: .languageCode)
            case 2: keyValueStore.set(value: Language.en.code, for: .languageCode)
            default: view.showAlertOnTop(withMessage: "Неизвестная ошибка".localized)
            }
        case themeListId:
            switch index {
            case 0: keyValueStore.set(value: Theme.light.rawValue, for: .theme)
            case 1: keyValueStore.set(value: Theme.dark.rawValue, for: .theme)
            default: view.showAlertOnTop(withMessage: "Неизвестная ошибка".localized)
            }
        case iconListId:
            setAppIcon(iconsListItems[safe: index]?.description)
        default: break
        }
        view.updateAllViews()
    }

    func getDigitalDocumentCell(from: [UITableViewCell]) -> UITableViewCell {
        return from.randomElement() ?? UITableViewCell()
    }
}

extension ProfileInteractor: AccessCodeConfirmFaceDelegate {
    
    func confirmFace() {
        view.showAlertOnTop(withMessage: "Вход в \(biometric.biometricType.name) включен".localized, lottie: nil)
        keyValueStore.set(value: true, for: .useBiometryToUnlock)
        
        guard let indexPath = getIndexPath(by: .loginWithFaceID) else { return }
        sections[indexPath.section].elements[indexPath.row].filedType = .switcher(isOn: true)
        view.update(at: indexPath)
    }
}

extension ProfileInteractor: AccessCodeChangeDelegate {
    
    func confirmChange() {
        view.showAlertOnTop(withMessage: "Код доступа изменен".localized, lottie: nil)
    }
}

extension ProfileInteractor: ChangePhoneDelegate {
    
    func confirm() {
        view.showAlertOnTop(withMessage: "Номер изменен".localized, lottie: nil)
    }
}

extension ProfileInteractor: AddEmailDelegate {
    
    func confirmAddEmail() {
        view.showAlertOnTop(withMessage: "Email изменен".localized, lottie: nil)
    }
}
