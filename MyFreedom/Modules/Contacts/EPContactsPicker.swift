//
//  EPContactsPickerViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 05.07.2022.
//

import UIKit
import Contacts

protocol EPContactsPickerViewInput: BaseViewControllerProtocol {
    func routeToBack()
    func routeToPervious()
    func routeToNext()
}

class EPContactsPicker: BaseViewController {

    typealias ContactsHandler = (_ contacts: [CNContact], _ error: NSError?) -> Void

    // MARK: - Properties
    var router: EPContactsPickerRouter?
    var interactor: EPContactsPickerInteractor?
    
    open weak var contactDelegate: EPPickerDelegate?
    public var contactsStore: CNContactStore?
    public var filterActive = false
    public var orderedContacts = [String: [CNContact]]() // Contacts ordered in dicitonary alphabetically
    public var sortedContactKeys = [String]()

    public var selectedContacts = [EPContact]()
    public var filteredContacts = [CNContact]()

    public var multiSelectEnabled: Bool = false // Default is single selection contact


    private lazy var goBackButton: UIBarButtonItem = .init(image: BaseImage.back.uiImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonAction))
    private let searchID = UUID()
    private var currentLevel: Int = -1
    private let maxLevel: Int = 2
    private let keyboardObserver: KeyboardStateObserver = .init()
    private lazy var bottomSafeConstraint = currentLevelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    private lazy var bottomConstraint = currentLevelView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    private lazy var currentLevelView = InputLevelView()
    private lazy var tpSearchTextField: TPTextFieldView<UUID> = build {
        $0.placeholder = "Имя или номер телефона"
        $0.keyboardType = .emailAddress
        $0.textField.textAlignment = .left
        $0.textField.textContentType = .name
        $0.backgroundColor = .none
        $0.delegate = self
        $0.addRightClearButton()
        $0.id = searchID
    }

    private let tableView: UITableView = build(UITableView(frame: .zero, style: .plain)) {
        $0.backgroundColor = BaseColor.base100
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.sectionIndexColor = BaseColor.base500
        $0.isOpaque = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0.0
        }

        $0.register(WrapperCell<EPContactView>.self)
        $0.register(WrapperCell<CFConditionsView>.self)
        $0.register(WrapperHeaderFooterView<ProductListHeaderView>.self)
        $0.register(WrapperHeaderFooterView<EmptyFooterView>.self)
    }


    // MARK: - Lifecycle Methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardObserver.stopListening()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        addSubviews()
        setupLayout()
        reloadContacts()
        configureKeyboardObserver()
    }

    private func configureSubviews() {
        title = "Номер телефона ребенка"
        goBackButton.tintColor = BaseColor.base900
        navigationItem.leftBarButtonItem = goBackButton
        view.backgroundColor = BaseColor.base100

        tpSearchTextField.set(height: 52)

        tableView.dataSource = self
        tableView.delegate = self

        guard let levelConfig = interactor?.getCurrentLevelConfig() else { return }
        currentLevelView.backgroundColor = BaseColor.base100
        currentLevelView.configure(currentLevel: levelConfig.currentLevel, maxLevel: levelConfig.maxLevel, delegate: self)

        keyboardObserver.startListening()
    }

    private func addSubviews() {
        view.addSubviews(tpSearchTextField, tableView)
        view.addSubview(currentLevelView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        tpSearchTextField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tpSearchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tpSearchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tpSearchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: tpSearchTextField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        currentLevelView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            currentLevelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentLevelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currentLevelView.heightAnchor.constraint(equalToConstant: 68),
            bottomSafeConstraint
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func configureKeyboardObserver() {
        keyboardObserver.keyboardStateHandler = { [weak self] params in
            guard let self = self else { return }
            switch params.state {
            case .willShow:
                self.bottomConstraint.constant = -abs(params.rect.height)
                self.bottomConstraint.isActive = true
                self.bottomSafeConstraint.isActive = false
                self.view.layoutIfNeeded()
            case .willHide:
                self.bottomConstraint.isActive = false
                self.bottomSafeConstraint.isActive = true
                self.view.layoutIfNeeded()
            }
        }
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Contact Operations

    @objc private func backButtonAction() {
        routeToBack()
    }

    open func reloadContacts() {
        getContacts({(_, error) in
            if error == nil {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
    }

    func getContacts(_ completion:  @escaping ContactsHandler) {
        if contactsStore == nil {
            // ContactStore is control for accessing the Contacts
            contactsStore = CNContactStore()
        }
        let error = NSError(domain: "EPContactPickerErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "No Contacts Access"])

        switch CNContactStore.authorizationStatus(for: CNEntityType.contacts) {
        case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
            // User has denied the current app to access the contacts.

            let productName = Bundle.main.infoDictionary!["CFBundleName"]!

            let alert = UIAlertController(title: "Unable to access contacts", message: "\(productName) does not have access to contacts. Kindly enable it in privacy settings ", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {  _ in
                completion([], error)
                self.dismiss(animated: true, completion: {
                    self.contactDelegate?.epContactPicker(self, didContactFetchFailed: error)
                })
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        case CNAuthorizationStatus.notDetermined:
            // This case means the user is prompted for the first time for allowing contacts
            contactsStore?.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, error) -> Void in
                // At this point an alert is provided to the user to provide access to contacts. This will get invoked if a user responds to the alert
                if  !granted {
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion([], error! as NSError?)
                    })
                } else {
                    self.getContacts(completion)
                }
            })

        case  CNAuthorizationStatus.authorized:
            // Authorization granted by user for this app.
            var contactsArray = [CNContact]()

            let contactFetchRequest = CNContactFetchRequest(keysToFetch: allowedContactKeys())

            do {
                try contactsStore?.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, _) -> Void in
                    // Ordering contacts based on alphabets in firstname
                    contactsArray.append(contact)
                    var key: String = "#"
                    // If ordering has to be happening via family name change it here.
                    if let firstLetter = contact.givenName[0..<1], firstLetter.containsAlphabets() {
                        key = firstLetter.uppercased()
                    }
                    var contacts = [CNContact]()

                    if let segregatedContact = self.orderedContacts[key] {
                        contacts = segregatedContact
                    }
                    contacts.append(contact)
                    self.orderedContacts[key] = contacts

                })
                self.sortedContactKeys = Array(self.orderedContacts.keys).sorted(by: <)
                if self.sortedContactKeys.first == "#" {
                    self.sortedContactKeys.removeFirst()
                    self.sortedContactKeys.append("#")
                }
                completion(contactsArray, nil)
            }
            // Catching exception as enumerateContactsWithFetchRequest can throw errors
            catch let error as NSError {
                print(error.localizedDescription)
            }

        @unknown default:
            print("@unknown default")
        }
    }

    func allowedContactKeys() -> [CNKeyDescriptor] {
        // We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
        return [CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor
        ]
    }


    // MARK: - Button Actions

    @objc func onTouchCancelButton() {
        dismiss(animated: true, completion: {
            self.contactDelegate?.epContactPicker(self, didCancel: NSError(domain: "EPContactPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        })
    }

    @objc func onTouchDoneButton() {
        dismiss(animated: true, completion: {
            self.contactDelegate?.epContactPicker(self, didSelectMultipleContacts: self.selectedContacts)
        })
    }
}

// MARK: - Search Actions

extension EPContactsPicker: TPTextFieldViewDelegate {

    func didEndEditing<ID>(text: String, forId id: ID) {
        self.bottomConstraint.isActive = false
        self.bottomSafeConstraint.isActive = true
        self.view.layoutIfNeeded()
    }

    func didChange<ID>(text: String, forId id: ID) {

        let predicate: NSPredicate
        if text.isEmpty {
            filterActive = false
            predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactsStore!.defaultContainerIdentifier())
        } else {
            filterActive = true
            predicate = text.isNumeric ? CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: text)) :  CNContact.predicateForContacts(matchingName: text)
        }

        let store = CNContactStore()
        do {
            filteredContacts = try store.unifiedContacts(matching: predicate,
                                                         keysToFetch: allowedContactKeys())
            // print("\(filteredContacts.count) count")

            self.tableView.reloadData()

        } catch {
            print("Error!")
        }
    }

    func didPressAuxilaryButton<ID>(forId id: ID) {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
}


// MARK: - Table View DataSource


extension EPContactsPicker: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        if filterActive { return 1 }
        return sortedContactKeys.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterActive { return filteredContacts.count == 0 ? 1 : filteredContacts.count }
        if let contactsForSection = orderedContacts[sortedContactKeys[section]] {
            return contactsForSection.count
        }
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: WrapperCell<EPContactView> = tableView.dequeueReusableCell(for: indexPath)
        cell.changeSeparator(color: .clear)
        cell.setRightMargin(constant: 0)
        cell.backgroundColor = .clear
//         Check empty
//        if (filterActive && filteredContacts.isEmpty) {
//            let emptyCell: WrapperCell<CFConditionsView> = tableView.dequeueReusableCell(for: indexPath)
////           
//        }

        // Convert CNContact to EPContact
        let contact: EPContact

        if filterActive {
            contact = EPContact(contact: filteredContacts[(indexPath as NSIndexPath).row])
        } else {
            guard let contactsForSection = orderedContacts[sortedContactKeys[(indexPath as NSIndexPath).section]] else {
                assertionFailure()
                return UITableViewCell()
            }

            contact = EPContact(contact: contactsForSection[(indexPath as NSIndexPath).row])
        }

        if multiSelectEnabled  && selectedContacts.contains(where: { $0.contactId == contact.contactId }) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }

        cell.innerView.configure(viewModel: contact, indexPath)
        return cell
    }

}


// MARK: - Table View Delegates

extension EPContactsPicker: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let contactsForSection = orderedContacts[sortedContactKeys[(indexPath as NSIndexPath).section]] else { return }
        let contact = EPContact(contact: contactsForSection[(indexPath as NSIndexPath).row])

        self.contactDelegate?.epContactPicker(self, didSelectContact: contact)
        interactor?.didSelectItem(at: indexPath)

        let cell = tableView.cellForRow(at: indexPath) as! WrapperCell<EPContactView>
        guard let selectedContact = cell.innerView.contact else { return }

        if multiSelectEnabled {
            // Keeps track of enable=ing and disabling contacts
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = UITableViewCell.AccessoryType.none
                selectedContacts = selectedContacts.filter {
                    return selectedContact.contactId != $0.contactId
                }
            } else {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                selectedContacts.append(selectedContact)
            }
        } else {
            // Single selection code
            filterActive = false
            if selectedContact.phoneNumbers.count > 1 {
                dismiss(animated: true) {
                    self.contactDelegate?.epContactPicker(self, didSelectContact: selectedContact)
                }
            } else if selectedContact.phoneNumbers.count == 1 {
                contactDelegate?.epContactPicker(self, didSelectContact: selectedContact)
                dismiss(animated: true, completion: nil)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if filterActive  { return 0 }
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: UITableView.ScrollPosition.top, animated: false)
        return sortedContactKeys.firstIndex(of: title)!
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if filterActive { return nil }
        return sortedContactKeys
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if filterActive { return nil }
        let header: WrapperHeaderFooterView<ProductListHeaderView> = tableView.dequeueReusableHeaderFooter()
        header.innerView.set(text: sortedContactKeys[section])
        return header
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if filterActive && filteredContacts.isEmpty { return nil }
        let footer: WrapperHeaderFooterView<EmptyFooterView> = tableView.dequeueReusableHeaderFooter()
        return footer
    }
}

extension EPContactsPicker: EPContactsPickerViewInput {

    func routeToBack() {
        router?.routeToBack()
    }

    func routeToNext() {
        router?.routeToNext()
    }

    func routeToPervious() {
        router?.routeToPervious()
    }
}

extension EPContactsPicker: InputLevelDelegate {

    func onBackButtonClicked() {
        routeToPervious()
    }

    func onNextButtonClicked() {
        routeToNext()
    }
}
