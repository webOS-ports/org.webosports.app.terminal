import QtQuick 2.0

Text {
    text: "[/home/test]$ pwd\n/home/test\n[/home/test]$"

    signal forceActiveFocus();

    property real scrollbarCurrentValue: 0
    property real scrollbarValue: 0
    property real scrollbarMinimum: 0
    property real scrollbarMaximum: 0
    property int lines: 80
    property string colorScheme
    property bool terminalUsesMouse: false
    property size terminalSize: Qt.size(80,45)
    property QMLTermSession session: QMLTermSession {}

    function simulateWheel(a, b, c, d, delta) {
        console.log("simulateWheel: delta = "+delta);
    }

    function simulateKeyPress(key, mod) {
        console.log("simulateKeyPress: key = "+key+", mod = "+mod);
    }
}
