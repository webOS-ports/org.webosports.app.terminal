import QtQuick
import QtQuick.Layouts

import Eos.Window 0.1
import LunaNext.Common 0.1

import "KeyboardRows" as Keyboard

WebOSWindow {
    id: appWindow

    // The card is not resized for the virtual keyboard, so make room for it
    readonly property real keyboardHeight: Qt.inputMethod.visible ? Qt.inputMethod.keyboardRectangle.height : 0

    // luna-next-cardshell rounds the card's corners with a 20 px radius
    // (CardWindowWrapper.cornerRadius), which cut into a character drawn in
    // the corner of the first row. Keep the text clear of the arc: its
    // deepest point along the diagonal, 20 * (1 - 1/sqrt(2)), is 6 px in.
    readonly property int cornerClearance: Math.ceil(20 * (1 - Math.SQRT1_2))

    width: Settings.displayWidth
    height: Settings.displayHeight
    visible: true
    windowType: "_WEBOS_WINDOW_TYPE_CARD"
    title: "Terminal"
    color: "black"

    Shortcut {
        sequence: "Ctrl+Shift+C"
        onActivated: terminal.copyClipboard()
    }

    Shortcut {
        sequence: "Ctrl+Shift+V"
        onActivated: terminal.pasteClipboard()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.bottomMargin: appWindow.keyboardHeight
        spacing: 0

        Terminal {
            id: terminal

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: appWindow.cornerClearance
            Layout.leftMargin: appWindow.cornerClearance
            Layout.rightMargin: appWindow.cornerClearance
        }

        Keyboard.KeyboardBar {
            Layout.fillWidth: true
            Layout.preferredHeight: Units.gu(5)

            onKeyRequested: (key, modifiers) => {
                terminal.pressKey(key, modifiers);
                terminal.forceActiveFocus();
            }
            onTextRequested: (text) => {
                terminal.sendText(text);
                terminal.forceActiveFocus();
            }
        }
    }

    Component.onCompleted: {
        terminal.forceActiveFocus();
        Qt.inputMethod.show();
    }
}
