import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Lipstick 1.0

MainPage {
    property alias tutorialTheme: tutorialThemeId
    property bool allowSystemGesturesBetweenLessons

    property bool _tutorialStarted
    property bool configurePeek: _tutorialStarted && !!__silica_applicationwindow_instance && !!__silica_applicationwindow_instance.window

    onStatusChanged: {
        if (status === PageStatus.Active) {
            // Don't override window and application window properties
            // before the tutorial really starts.
            _tutorialStarted = true
        }
    }
    onConfigurePeekChanged: {
        if (configurePeek) {
            __silica_applicationwindow_instance.window.PeekFilter.pressDelay = 200
            __silica_applicationwindow_instance.window.PeekFilter.threshold = Screen.width / 4
            __silica_applicationwindow_instance.window.PeekFilter.boundaryWidth = Theme.paddingLarge
            __silica_applicationwindow_instance.window.PeekFilter.boundaryHeight = Theme.paddingLarge
        }
    }

    QtObject {
        id: tutorialThemeId
        property color highlightColor: "#88f5e0"
        property color secondaryHighlightColor: "#b588f5e0"
        property color primaryColor: "#ffffffff"
        property color secondaryColor: "#b0ffffff"
        property color highlightBackgroundColor: "#00e6b9"
        property color highlightDimmerColor: "#003329"
    }
}
