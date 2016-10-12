import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Telephony 1.0
import org.nemomobile.dbus 2.0

SimSelectorBase {
    id: root

    property bool updateSelectedSim: true
    property bool restrictToActive

    signal simSelected(int sim, string modemPath)

    width: parent.width
    height: simIndicators.height
    controlType: SimManagerType.Voice
    modemManager.objectName: "SimSelector"

    function simInfo(simIndex) {
        return modemManager.modemSimModel.get(simIndex)
    }

    Row {
        id: simIndicators

        width: parent.width
        Repeater {
            enabled: root.active
            model: modemManager.modemSimModel

            delegate: BackgroundItem {
                id: backgroundItem

                readonly property bool canHighlight: (!simIndicator.selected || Telephony.voiceSimUsageMode === Telephony.AlwaysAskSim)

                width: parent.width / 2
                height: Math.max(simIndicator.height + Theme.paddingMedium * 2, simIndicators.implicitHeight)
                // Disabling the whole component passes the event to the component under this.
                // Thus, better to consume the event.
                highlightedColor: canHighlight ? Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                                               : "transparent"

                // This assumes we have a DSDS modem, which is the only type supported at the moment.
                enabled: !restrictToActive || modemManager.activeVoiceCallModems.length === 0 || modemManager.activeVoiceCallModems[0] === modem
                opacity: !modemEnabled || errorState.errorState == "noSimInserted" || !enabled ? 0.4 : 1.0
                Behavior on opacity {
                    FadeAnimation {}
                }

                onClicked: {
                    if (errorState.errorState === "modemDisabled") {
                        settings.showSimCards()
                    } else if (index != root.activeSim && updateSelectedSim) {
                        setActiveSimIndex(index)
                    } else if (errorState.errorState === "simActivationRequired") {
                        pinQuery.requestSimPin(modem)
                    } else {
                        root.simSelected(index, modem)
                    }
                }

                SimErrorState {
                    id: errorState
                    multiSimManager: root.modemManager
                    modemPath: modem
                }

                SimIndicator {
                    id: simIndicator

                    horizontalAlignment: index == 0 ? Text.AlignRight : Text.AlignLeft
                    description: shortSimDescription
                    valid: !errorState.errorState
                    operator: valid ? operatorDescription : errorState.shortErrorString
                    selected: root.activeSim === index && Telephony.voiceSimUsageMode === Telephony.ActiveSim
                    highlighted: backgroundItem.highlighted && backgroundItem.canHighlight
                }
            }
        }
    }

    DBusInterface {
        id: settings

        service: "com.jolla.settings"
        path: "/com/jolla/settings/ui"
        iface: "com.jolla.settings.ui"

        function showSimCards() {
            settings.call("showPage", "system_settings/connectivity/multisim")
        }
    }

    DBusInterface {
        id: pinQuery

        service: "com.jolla.PinQuery"
        path: "/com/jolla/PinQuery"
        iface: "com.jolla.PinQuery"

        function requestSimPin(modemPath)  {
            call("requestSimPin", [ modemPath ])
        }
    }
}
