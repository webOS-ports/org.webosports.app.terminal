import QtQuick 2.12

import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import LuneOS.Components 1.0
import LunaNext.Common 0.1

import QMLTermWidget 1.0
import "KeyboardRows" as Keyboard

Rectangle {
    Action {
        onTriggered: terminal.copyClipboard();
        shortcut: "Ctrl+Shift+C"
    }

    Action {
        onTriggered: terminal.pasteClipboard();
        shortcut: "Ctrl+Shift+V"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Terminal {
            id: terminal
            Layout.fillHeight: true
            Layout.fillWidth: true
            focus: true
        }

        Loader {
            id: keyboardBarLoader
            Layout.fillWidth: true
            active: true //Qt.inputMethod.visible
            Layout.preferredHeight: Units.gu(6)

            sourceComponent: Keyboard.KeyboardBar {
                onSimulateSequence: terminal.simulateKeySequence(sequence);
                onSimulateCommand: terminal.sendText(command);
            }
        }

        Item {
            Layout.minimumHeight: Qt.inputMethod.keyboardRectangle.height
            Layout.fillWidth: true
        }
    }

    Component.onCompleted: terminal.forceActiveFocus();
}
