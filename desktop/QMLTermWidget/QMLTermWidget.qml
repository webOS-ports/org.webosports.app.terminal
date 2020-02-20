import QtQuick 2.0

Text {
    text: "[/home/test]$ pwd\n/home/test\n[/home/test]$"

    property string colorScheme
    property bool terminalUsesMouse: false
    property size terminalSize: Qt.size(80,45)
    property QMLTermSession session: QMLTermSession {}
}
