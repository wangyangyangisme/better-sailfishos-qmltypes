import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property string title
    property url selectedContent
    property variant selectedContentProperties
    property bool popOnSelection: true

    // The last page from application
    property Item _lastAppPage
    property int _animationDuration: 150

    property Component _background

    function _customSelectionHandler(model, index, selected) {
        _handleSelection(model, index, selected)
    }

    function _handleSelection(model, index, selected) {
        model.updateSelected(index, selected)
        _handleSelectionProperties(model.get(index))
    }

    function _handleSelectionProperties(properties) {
        selectedContentProperties = properties
        selectedContent = properties.url

        if (popOnSelection) {
            _navigation = PageNavigation.Forward
            if (_lastAppPage) {
                pageStack.pop(_lastAppPage)
            } else {
                pageStack.pop()
            }
        }
    }

    Item {
        id: background
        anchors.fill: parent
    }

    Component.onCompleted: {
        if (_background) {
            _background.createObject(background)
        }
    }
}
