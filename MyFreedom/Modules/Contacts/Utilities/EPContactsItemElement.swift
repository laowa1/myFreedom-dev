//
//  EPPickerDelegate.swift
//  MyFreedom
//
//  Created by &&TairoV on 05.07.2022.
//

protocol EPPickerDelegate: AnyObject {
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error: NSError)
    func epContactPicker(_: EPContactsPicker, didCancel error: NSError)
    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact)
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact])
}

extension EPPickerDelegate {
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error: NSError) { }
    func epContactPicker(_: EPContactsPicker, didCancel error: NSError) { }
    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact) { }
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) { }
}

import UIKit
import Contacts

open class EPContact {

    open var firstName: String
    open var lastName: String
    open var company: String
    open var thumbnailProfileImage: UIImage?
    open var profileImage: UIImage?
    open var birthday: Date?
    open var birthdayString: String?
    open var contactId: String?
    open var phoneNumbers = [(phoneNumber: String, phoneLabel: String)]()
    open var emails = [(email: String, emailLabel: String )]()

    public init (contact: CNContact) {
        firstName = contact.givenName
        lastName = contact.familyName
        company = contact.organizationName
        contactId = contact.identifier

        if let thumbnailImageData = contact.thumbnailImageData {
            thumbnailProfileImage = UIImage(data: thumbnailImageData)
        }

        if let imageData = contact.imageData {
            profileImage = UIImage(data: imageData)
        }

        if let birthdayDate = contact.birthday {

            birthday = Calendar(identifier: Calendar.Identifier.gregorian).date(from: birthdayDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-DD"
            // Example Date Formats:  Oct 4, Sep 18, Mar 9
            birthdayString = dateFormatter.string(from: birthday!)
        }

        for phoneNumber in contact.phoneNumbers {
                    var phoneLabel = "phone"
                    if let label = phoneNumber.label {
                        phoneLabel = label
                    }
            let phone = phoneNumber.value.stringValue

            phoneNumbers.append((phone, phoneLabel))
        }

        for emailAddress in contact.emailAddresses {
            guard let emailLabel = emailAddress.label else { continue }
            let email = emailAddress.value as String

            emails.append((email, emailLabel))
        }
    }

    open func displayName() -> String {
        return firstName + " " + lastName
    }

    open func contactInitials() -> String {
        var initials = String()

        if let firstNameFirstChar = firstName.first {
            initials.append(firstNameFirstChar)
        }

        if let lastNameFirstChar = lastName.first {
            initials.append(lastNameFirstChar)
        }

        return initials
    }

}
