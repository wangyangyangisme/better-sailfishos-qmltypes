// -*- qml -*-

import QtQuick 2.0
import Sailfish.Media 1.0
import org.nemomobile.policy 1.0
import com.jolla.mediaplayer 1.0

Item {
    id: mediaKeys

    property bool active
    property bool _grabKeys: AudioPlayer.active && keysResource.acquired

    Permissions {
        enabled: mediaKeys.active
        applicationClass: "player"

        Resource {
            id: keysResource
            type: Resource.HeadsetButtons
            optional: true
        }
    }

    MediaKey { enabled: _grabKeys; key: Qt.Key_MediaTogglePlayPause; onReleased: AudioPlayer.playPause() }
    MediaKey { enabled: _grabKeys; key: Qt.Key_MediaPlay; onReleased: AudioPlayer.play() }
    MediaKey { enabled: _grabKeys; key: Qt.Key_MediaPause; onReleased: AudioPlayer.pause() }
    MediaKey { enabled: _grabKeys; key: Qt.Key_MediaStop; onReleased: AudioPlayer.stop() }
    MediaKey { enabled: _grabKeys; key: Qt.Key_MediaNext; onReleased: AudioPlayer.playNext(false) }
    MediaKey { enabled: _grabKeys; key: Qt.Key_MediaPrevious; onReleased: AudioPlayer.playPrevious(false) }
    MediaKey { enabled: _grabKeys; key: Qt.Key_ToggleCallHangup; onReleased: AudioPlayer.playPause() }

    MediaKey {
        id: forwardKey

        enabled: _grabKeys
        key: Qt.Key_AudioForward
        onPressed: AudioPlayer.forwarding = true
        onRepeat: {
            AudioPlayer.setSeekRepeat(true)
            AudioPlayer.forwarding = true
        }
        onReleased: AudioPlayer.forwarding = false
    }

    MediaKey {
        id: rewindKey

        enabled: _grabKeys
        key: Qt.Key_AudioRewind
        onPressed: AudioPlayer.rewinding = true
        onRepeat: {
            AudioPlayer.setSeekRepeat(true)
            AudioPlayer.rewinding = true
        }
        onReleased: AudioPlayer.rewinding = false
    }
}
