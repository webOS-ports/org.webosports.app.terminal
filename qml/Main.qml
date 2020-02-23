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
        QMLTermWidget {
            id: terminal
            Layout.fillWidth: true
            Layout.fillHeight: true
            font.family: "Monospace"
            font.pointSize: FontUtils.sizeToPixels("small")
            colorScheme: "cool-retro-term"
            focus: true

            session: QMLTermSession{
                id: mainsession
                initialWorkingDirectory: "$HOME"
                onMatchFound: {
                    console.log("found at: %1 %2 %3 %4".arg(startColumn).arg(startLine).arg(endColumn).arg(endLine));
                }
                onNoMatchFound: {
                    console.log("not found");
                }
            }

            onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
            onTerminalSizeChanged: console.log(terminalSize);
            Component.onCompleted: mainsession.startShellProgram();

            QMLTermScrollbar {
                terminal: terminal
                width: 20
                Rectangle {
                    opacity: 0.4
                    anchors.margins: Units.gu(5)
                    radius: width * 0.5
                    anchors.fill: parent
                }
            }

            MouseArea {
                anchors.fill: parent
                property real oldY
                onPressed: oldY = mouse.y
                onPositionChanged: {
                    terminal.simulateWheel(0, 0, 0, 0, Qt.point(0, (mouse.y - oldY)*2))
                    oldY = mouse.y
                }
                onClicked: {
                    Qt.inputMethod.show();
                }
            }
        }

        Loader {
            id: keyboardBarLoader
            Layout.fillWidth: true
            active: true //Qt.inputMethod.visible

            sourceComponent: Keyboard.KeyboardBar {
                height: Units.gu(5)
                backgroundColor: "grey"
                foregroundColor: "orange"
                onSimulateSequence: terminal.simulateKeySequence(sequence);
                onSimulateCommand: mainsession.sendText(command);
            }
        }

        Item {
            Layout.minimumHeight: Qt.inputMethod.keyboardRectangle.height
            Layout.fillWidth: true
        }
    }

    Component.onCompleted: terminal.forceActiveFocus();
}
