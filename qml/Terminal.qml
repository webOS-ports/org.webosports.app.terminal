import QtQuick
import QtQuick.Controls

import LunaNext.Common 0.1

import QMLTermWidget 2.0

QMLTermWidget {
    id: terminal

    // One wheel step of the terminal: 5 degrees, in eighths of a degree,
    // which scrolls the history by a line
    readonly property int wheelStep: 40

    function sendText(text) {
        session.sendText(text);
    }

    function pressKey(key, modifiers) {
        simulateKeyPress(key, modifiers, true, 0, "");
    }

    function pressKeyRepeatedly(key, times) {
        for (let i = 0; i < times; ++i)
            pressKey(key, Qt.NoModifier);
    }

    function scrollHistory(steps) {
        const delta = steps > 0 ? wheelStep : -wheelStep;

        for (let i = 0; i < Math.abs(steps); ++i)
            simulateWheel(width / 2, height / 2, Qt.NoButton, Qt.NoModifier, Qt.point(0, delta));
    }

    // Whole, so the widget's default point size does not linger next to
    // the pixel size
    font: Qt.font({ "family": "Liberation Mono", "pixelSize": FontUtils.sizeToPixels("medium") })
    colorScheme: "cool-retro-term"
    focus: true

    session: QMLTermSession {
        initialWorkingDirectory: "$HOME"
        onFinished: Qt.quit()
    }

    Component.onCompleted: session.startShellProgram()

    TerminalInputArea {
        anchors.fill: parent

        // A swipe step of one text line feels like dragging the text
        swipeDelta: terminal.fontMetrics.height

        onTouchPress: terminal.forceActiveFocus()
        onTouchClick: (x, y) => {
            // A full click, so programs that take the mouse (mc, htop) see one,
            // and otherwise to clear any selection
            terminal.simulateMousePress(x, y, Qt.LeftButton, Qt.LeftButton, Qt.NoModifier);
            terminal.simulateMouseRelease(x, y, Qt.LeftButton, Qt.NoButton, Qt.NoModifier);
            Qt.inputMethod.show();
        }
        onTouchPressAndHold: (x, y) => editMenu.popup(x, y)

        // One finger walks the cursor and the shell history, two scroll back
        onSwipeYDetected: (steps) => terminal.pressKeyRepeatedly(steps > 0 ? Qt.Key_Down : Qt.Key_Up,
                                                                 Math.abs(steps))
        onSwipeXDetected: (steps) => terminal.pressKeyRepeatedly(steps > 0 ? Qt.Key_Right : Qt.Key_Left,
                                                                 Math.abs(steps))
        onTwoFingerSwipeYDetected: (steps) => terminal.scrollHistory(steps)
    }

    ScrollBar {
        id: historyBar

        readonly property int totalLines: terminal.lines + terminal.scrollbarMaximum - terminal.scrollbarMinimum

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        orientation: Qt.Vertical
        interactive: false
        size: totalLines > 0 ? terminal.lines / totalLines : 1
        position: totalLines > 0 ? (terminal.scrollbarCurrentValue - terminal.scrollbarMinimum) / totalLines : 0
        active: hideTimer.running

        Timer {
            id: hideTimer

            interval: 1000
        }

        Connections {
            target: terminal

            function onScrollbarParamsChanged() {
                hideTimer.restart();
            }
        }
    }

    Menu {
        id: editMenu

        focus: false

        MenuItem {
            text: "Copy"
            onTriggered: terminal.copyClipboard()
        }

        MenuItem {
            text: "Paste"
            onTriggered: terminal.pasteClipboard()
        }
    }
}
