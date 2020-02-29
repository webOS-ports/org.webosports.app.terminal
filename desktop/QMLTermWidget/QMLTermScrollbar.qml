import QtQuick 2.12
import QMLTermWidget 1.0

import LunaNext.Common 0.1

Item {
    property QMLTermWidget terminal

    property int value: terminal.scrollbarCurrentValue
    property int minimum: terminal.scrollbarMinimum
    property int maximum: terminal.scrollbarMaximum
    property int lines: terminal.lines
    property int totalLines: lines + maximum

    opacity: 1.0

    height: terminal.height * (lines / (totalLines - minimum))
    y: (terminal.height / (totalLines)) * (value - minimum)

    Behavior on opacity {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    function showScrollbar() {
        opacity = 1.0;
        hideTimer.restart();
    }

    Connections {
        target: terminal
        onScrollbarValueChanged: showScrollbar();
    }

    Timer {
        id: hideTimer
        onTriggered: parent.opacity = 0;
    }
}
