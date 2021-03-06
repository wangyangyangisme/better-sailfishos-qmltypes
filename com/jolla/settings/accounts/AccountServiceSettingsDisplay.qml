import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Accounts 1.0

Column {
    id: root

    property bool showSectionHeader: true
    property var serviceModel
    property bool autoEnableServices

    width: parent.width
    spacing: Theme.paddingMedium

    signal updateServiceEnabledStatus(string serviceName, bool enabled)

    Behavior on opacity { FadeAnimation {} }

    SectionHeader {
        visible: root.showSectionHeader
        //: Heading for other account services not already listed
        //% "Other services"
        text: qsTrId("settings-accounts-la-other_services")
    }

    Repeater {
        model: serviceModel

        IconTextSwitch {
            // this is a workaround for future-proofing, we want to keep some facebook services
            // around but make sure they are never enabled (or visible to the user)
            // until they can be removed altogether in a future update
            visible: model.serviceName !== "facebook-im" && model.serviceName !== "facebook-contacts" && model.serviceName !== "facebook-microblog"
            icon.source: model.iconName
            text: model.displayName
            description: model.description
            checked: model.enabled
            onClicked: {
                root.updateServiceEnabledStatus(model.serviceName, checked)
            }
        }
    }
}
