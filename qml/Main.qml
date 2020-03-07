import QtQuick 2.12

import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import LuneOS.Components 1.0
import LunaNext.Common 0.1

import QMLTermWidget 1.0
import "KeyboardRows" as Keyboard

Rectangle {
    id: root

    Action {
        onTriggered: terminal.copyClipboard();
        shortcut: "Ctrl+Shift+C"
    }

    Action {
        onTriggered: terminal.pasteClipboard();
        shortcut: "Ctrl+Shift+V"
    }

    Column {
        width: parent.width
        spacing: 0

        Terminal {
            id: terminal
            width: parent.width
            height: root.height - keyboardBarLoader.height - keyboardHeight

            property real keyboardHeight: Qt.inputMethod.visible ? Qt.inputMethod.keyboardRectangle.height : 0
        }

        Loader {
            id: keyboardBarLoader
            width: parent.width
            active: true //Qt.inputMethod.visible
            height: Units.gu(5)

            sourceComponent: Keyboard.KeyboardBar {
                onSimulateSequence: terminal.simulateKeySequence(sequence);
                onSimulateCommand: terminal.sendText(command);
            }
        }
    }

    Component.onCompleted: {
        terminal.forceActiveFocus();
    }
}
