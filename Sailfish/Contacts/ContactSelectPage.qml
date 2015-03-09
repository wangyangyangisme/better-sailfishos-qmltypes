import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Contacts 1.0
import org.nemomobile.contacts 1.0

Page {
    id: root
    allowedOrientations: Orientation.All

    property string searchPlaceholderText: contactBrowser.searchPlaceholderText
    property bool showSearchPatternAsNewContact: false
    property alias allContactsModel: contactBrowser.allContactsModel
    property alias requiredProperty: contactBrowser.requiredProperty
    property alias showRecentContactList: contactBrowser.showRecentContactList
    property alias searchEnabled: contactBrowser.searchEnabled
    property bool searchMenuEnabled

    property string title: requiredProperty == PeopleModel.PhoneNumberRequired ?
                           //: Page title of contact phone number selector
                           //% "Select number"
                           qsTrId("components_pickers-he-select_phone_number") :
                           (requiredProperty == PeopleModel.EmailAddressRequired ?
                           //: Page title of contact email address selector
                           //% "Select email"
                           qsTrId("components_pickers-he-select_email_address") :
                           //: Page title of contact selector
                           //% "Select contact"
                           qsTrId("components_pickers-he-select_contact"))

    signal contactClicked(variant contact, variant clickedItemY, variant property, string propertyType)

    ContactBrowser {
        id: contactBrowser

        contactsSelectable: false
        searchEnabled: true
        focus: false
        showSearchPatternAsNewContact: root.showSearchPatternAsNewContact

        onContactClicked: root.contactClicked(contact, clickedItemY, property, propertyType)

        topContent: [
            PageHeader {
                title: root.title
            }
        ]

        PullDownMenu {
            visible: searchMenuEnabled
            enabled: contactBrowser.allContactsModel.count > 0
            MenuItem {
                                                   //: Hide contact search view
                                                   //% "Hide search"
                text: contactBrowser.searchEnabled ? qsTrId("components_pickers-me-hide_search")
                                                   //: Show contact search view
                                                   //% "Show search"
                                                   : qsTrId("components_pickers-me-show_search")

                onClicked: contactBrowser.searchEnabled = !contactBrowser.searchEnabled
            }
        }
    }
}