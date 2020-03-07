import QtQuick 2.12

import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import LuneOS.Components 1.0
import LunaNext.Common 0.1

import QMLTermWidget 1.0
import "KeyboardRows" as Keyboard

QMLTermWidget {
    id: terminal
    font.family: "Monospace"
    font.pointSize: FontUtils.sizeToPixels("xx-small")
    colorScheme: "cool-retro-term"
    focus: true
    session: QMLTermSession{
        id: mainsession
        initialWorkingDirectory: "$HOME"
        onFinished: terminal.close()
    }
    
    function sendText(text) {
        mainsession.sendText(text);
    }

    function close() {
        Qt.quit()
    }

    onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
    onTerminalSizeChanged: console.log(terminalSize);
    Component.onCompleted: {
        mainsession.startShellProgram();
        terminal.forceActiveFocus();
        Qt.inputMethod.show();
    }

    TerminalInputArea {
        id: inputArea
        //enabled: terminalPage.state != "SELECTION"
        anchors.fill: parent
        // FIXME: should anchor to the bottom of the window to cater for the case when the OSK is up

        // This is the minimum wheel event registered by the plugin (with the current settings).
        property real wheelValue: 40

        // This is needed to fake a "flickable" scrolling.
        swipeDelta: terminal.fontMetrics.height

        // Touch actions
        onTouchPress: {
            terminal.forceActiveFocus(0);
            terminal.simulateMousePress(x, y, Qt.LeftButton, Qt.LeftButton, Qt.NoModifier);
        }
        onTouchClick: {
            terminal.forceActiveFocus(0);
            if(!Qt.inputMethod.visible) Qt.inputMethod.show();
        //    terminal.simulateKeyPress(Qt.Key_Tab, Qt.NoModifier, true, 0, "");
        }
        onTouchPressAndHold: alternateAction(x, y);

        // Swipe actions
        onSwipeYDetected: {
            if (steps > 0) {
                simulateSwipeDown(steps);
            } else {
                simulateSwipeUp(-steps);
            }
        }
        onSwipeXDetected: {
            if (steps > 0) {
                simulateSwipeRight(steps);
            } else {
                simulateSwipeLeft(-steps);
            }
        }
        onTwoFingerSwipeYDetected: {
            if (steps > 0) {
                simulateDualSwipeDown(steps);
            } else {
                simulateDualSwipeUp(-steps);
            }
        }

        function simulateSwipeUp(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Up, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateSwipeDown(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Down, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateSwipeLeft(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Left, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateSwipeRight(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Right, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateDualSwipeUp(steps) {
            while(steps > 0) {
                terminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, -wheelValue));
                steps--;
            }
        }
        function simulateDualSwipeDown(steps) {
            while(steps > 0) {
                terminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, wheelValue));
                steps--;
            }
        }
    }

    QMLTermScrollbar {
        terminal: terminal
        anchors.right: terminal.right
        width: Units.gu(4)

        Rectangle {
            color: "lightblue"
            opacity: 0.4
            anchors.margins: Units.gu(0.5)
            radius: width * 0.5
            anchors.fill: parent
        }
    }
}
