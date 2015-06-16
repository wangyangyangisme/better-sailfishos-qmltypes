import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Timezone 1.0

Page {
    id: root

    property alias model: view.model

    signal countryClicked(string countryName, string countryCode)

    SilicaListView {
        id: view

        anchors.fill: parent
        currentIndex: -1
        focus: true
        model: CountryModel {}
        header: Column {
            width: view.width

            PageHeader {
                id: pageHeader

                //% "Country"
                title: qsTrId("components_timezone-he-country")
            }

            Item {
                id: searchFieldPlaceholder
                width: parent.width
                height: root.isLandscape ? 0 : searchField.height
            }

            SearchField {
                id: searchField

                parent: root.isLandscape ? pageHeader.extraContent : searchFieldPlaceholder

                width: view.width
                anchors.verticalCenter: parent.verticalCenter

                focus: true
                Binding {
                    target: view.model
                    property: "filter"
                    value: searchField.text.toLowerCase().trim()
                }
            }

            Connections {
                target: searchField.activeFocus ? view : null
                ignoreUnknownSignals: true
                onContentYChanged: {
                    if (view.contentY > (Screen.height / 2)) {
                        searchField.focus = false
                    }
                }
            }
        }
        delegate: BackgroundItem {
            id: background
            height: Theme.itemSizeSmall
            onClicked: root.countryClicked(model.countryName, model.countryCode)
            Label {
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                textFormat: Text.StyledText
                text: {
                    if (view.model.filter == "") {
                        return model.countryName
                    }
                    var regexp = new RegExp('\\b' + view.model.filter, 'i')
                    if (regexp.test(model.countryName)) {
                        return Theme.highlightText(model.countryName, regexp, Theme.highlightColor)
                    } else {
                        Theme.highlightText(model.countryName, view.model.filter, Theme.highlightColor)
                    }
                }
                color: background.down ? Theme.highlightColor : Theme.primaryColor
            }
        }

        VerticalScrollDecorator {}
    }
}
