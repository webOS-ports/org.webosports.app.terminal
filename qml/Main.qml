import QtQuick
import QtQuick.Layouts

import Eos.Window 0.1
import LunaNext.Common 0.1
import LuneOS.Service 1.0

import "KeyboardRows" as Keyboard

WebOSWindow {
    id: appWindow

    // The card is not resized for the virtual keyboard, so make room for it:
    // as much of the window as the keyboard covers, from its top edge down. Not
    // its height, because the keyboard reaches past the card's bottom edge into
    // the shell's area below it - on the Q25 the bar ended up 64 px above the
    // keys. The rectangle arrives in the coordinates of the keyboard's surface,
    // which on LuneOS starts where the card does, under the status bar.
    // Only a rectangle that reaches the bottom of the window is taken for a
    // keyboard: an input method has been seen to report a sliver at the top
    // of its panel while showing nothing.
    readonly property real keyboardHeight: {
        const rect = Qt.inputMethod.keyboardRectangle;
        if (!Qt.inputMethod.visible || rect.height <= 0 || rect.y + rect.height < height)
            return 0;
        return Math.max(0, Math.min(height, height - rect.y));
    }

    // luna-next-cardshell rounds the card's corners with a 20 px radius
    // (CardWindowWrapper.cornerRadius), which cut into a character drawn in
    // the corner of the first row. Keep the text clear of the arc: its
    // deepest point along the diagonal, 20 * (1 - 1/sqrt(2)), is 6 px in.
    readonly property int cornerClearance: Math.ceil(20 * (1 - Math.SQRT1_2))

    // Set by main.cpp from LS2_NAME
    property string ls2Name

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

    function focusTerminal() {
        terminal.forceActiveFocus();
        Qt.inputMethod.show();
    }

    // The app manager restarts a native app that has not registered with it
    // whenever it is launched again, and tapping the app menu is such a
    // launch: it killed the shell and everything running in it. Registered,
    // the app is sent the launch as an event instead, and a close too.
    Loader {
        active: appWindow.ls2Name !== ""
        sourceComponent: LunaService {
            name: appWindow.ls2Name

            Component.onCompleted: subscribe("luna://com.webos.applicationManager/registerApp", "{}",
                                             (message) => {
                const event = JSON.parse(message.payload).event;
                if (event === "relaunch")
                    appWindow.focusTerminal();
                else if (event === "close")
                    Qt.quit();
            }, (message) => console.warn("Could not register with the app manager:", message.payload))
        }
    }

    Component.onCompleted: focusTerminal()
}
