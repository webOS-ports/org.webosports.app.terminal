import QtQuick 2.12

import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import LuneOS.Components 1.0
import LunaNext.Common 0.1

import QMLTermWidget 1.0

Rectangle {
    Shortcut {
        onActivated: terminal.copyClipboard();
        sequence: "Ctrl+Shift+C"
    }

    Shortcut {
        onActivated: terminal.pasteClipboard();
        sequence: "Ctrl+Shift+V"
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
                    anchors.margins: 5
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
        RowLayout {
            ToolButton {
                Layout.maximumWidth: height
                text: "Tab"
                onClicked: terminal.simulateKeyPress(Qt.Key_Tab, 0, true, 0, "")
            }
            ToolButton {
                Layout.maximumWidth: height
                text: "←"
                onClicked: terminal.simulateKeyPress(Qt.Key_Left, 0, true, 0, "")
            }
            ToolButton {
                Layout.maximumWidth: height
                text: "↑"
                onClicked: terminal.simulateKeyPress(Qt.Key_Up, 0, true, 0, "")
            }
            ToolButton {
                Layout.maximumWidth: height
                text: "→"
                onClicked: terminal.simulateKeyPress(Qt.Key_Right, 0, true, 0, "")
            }
            ToolButton {
                Layout.maximumWidth: height
                text: "↓"
                onClicked: terminal.simulateKeyPress(Qt.Key_Down, 0, true, 0, "")
            }
            ToolButton {
                Layout.maximumWidth: height
                text: "|"
                onClicked: terminal.simulateKeyPress(Qt.Key_Bar, 0, true, 0, "|")
            }
            ToolButton {
                Layout.maximumWidth: height
                text: "~"
                onClicked: terminal.simulateKeyPress(Qt.Key_AsciiTilde, 0, true, 0, "~")
            }
        }
        Item {
            Layout.minimumHeight: Qt.inputMethod.keyboardRectangle.height
            Layout.fillWidth: true
        }
    }


    Component.onCompleted: terminal.forceActiveFocus();
}
