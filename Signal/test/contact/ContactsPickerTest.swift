//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import XCTest
import Contacts
@testable import Signal

final class ContactsPickerTest: XCTestCase {
    private var prevLang: Any?

    override func setUp() {
        super.setUp()

        prevLang = getLang()
    }

    override func tearDown() {
        super.tearDown()

        if let prevLang = prevLang {
            setLang(value: prevLang)
        }
    }

    @available(iOS 9.0, *)
    func testContactSectionMatchesEmailFirstLetterWhenOnlyEmailContact() {
        setLangEN()

        let emailOnlyContactB = CNMutableContact()
        emailOnlyContactB.emailAddresses.append(CNLabeledValue(label: nil, value: "bla@bla.com"))

        let emailOnlyContactD = CNMutableContact()
        emailOnlyContactD.emailAddresses.append(CNLabeledValue(label: nil, value: "dude@bla.com"))

        let contactsPicker = ContactsPicker(delegate: nil)
        let collatedContacts = contactsPicker.collatedContacts([emailOnlyContactB, emailOnlyContactD])

        let sectionTitles = contactsPicker.collation.sectionTitles
        if let bIndex = sectionTitles.index(of: "B") {
            let bSectionContacts = collatedContacts[bIndex]
            XCTAssertEqual(bSectionContacts.first, emailOnlyContactB)
        }

        if let dIndex = sectionTitles.index(of: "D") {
            let dSectionContacts = collatedContacts[dIndex]
            XCTAssertEqual(dSectionContacts.first, emailOnlyContactD)
        }
    }

    @available(iOS 9.0, *)
    func testContactSectionMatchesNameFirstLetterWhenNameExistsInContact() {
        setLangEN()

        let nameAndEmailContact = CNMutableContact()
        nameAndEmailContact.givenName = "Alice"
        nameAndEmailContact.emailAddresses.append(CNLabeledValue(label: nil, value: "nameAndEmail@bla.com"))

        let contactsPicker = ContactsPicker(delegate: nil)
        let collatedContacts = contactsPicker.collatedContacts([nameAndEmailContact])

        let sectionTitles = contactsPicker.collation.sectionTitles
        if let aIndex = sectionTitles.index(of: "A") {
            let aSectionContacts = collatedContacts[aIndex]
            XCTAssertEqual(aSectionContacts.first, nameAndEmailContact)
        }
    }

    private func setLangEN() {
        setLang(value: "en")
    }

    private func setLang(value: Any) {
        UserDefaults.standard.set(value, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }

    private func setLang(value: String) {
        setLang(value: [value])
    }

    private func getLang() -> Any? {
        return UserDefaults.standard.value(forKey: "AppleLanguages")
    }
}
