/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored-by: Filippo Scognamiglio <flscogna@gmail.com>
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.LuneOS

import LunaNext.Common 0.1

import "Layouts.js" as Layouts

/*
 * The row of keys a virtual keyboard lacks (Ctrl, Esc, arrows, function keys)
 * and some ready-made commands, one layout at a time.
 */
ToolBar {
    id: keyboardBar

    property int layoutIndex: 0
    readonly property var layout: Layouts.layouts[layoutIndex]

    // modifiers is a Qt.KeyboardModifiers value
    signal keyRequested(int key, int modifiers)
    signal textRequested(string text)

    /*
     * Turns "Ctrl+Shift+X" into a Qt key code and modifiers, or null when
     * the combination names a key Qt does not have.
     */
    function parseKey(combination) {
        const modifierFlags = { "Ctrl": Qt.ControlModifier, "Shift": Qt.ShiftModifier,
                                "Alt": Qt.AltModifier, "Meta": Qt.MetaModifier };
        const parts = combination.split("+");
        const key = Qt["Key_" + parts.pop()];
        let modifiers = Qt.NoModifier;

        if (key === undefined)
            return null;

        for (const part of parts) {
            if (!Object.prototype.hasOwnProperty.call(modifierFlags, part))
                return null;
            modifiers |= modifierFlags[part];
        }

        return { "key": key, "modifiers": modifiers };
    }

    function trigger(action) {
        if (action.text !== undefined) {
            textRequested(action.text);
            return;
        }

        const parsed = parseKey(action.key);
        if (parsed)
            keyRequested(parsed.key, parsed.modifiers);
        else
            console.warn("Terminal: no such key combination: " + action.key);
    }

    padding: 0

    Button {
        id: layoutSelector

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        text: keyboardBar.layout.name
        focusPolicy: Qt.NoFocus
        implicitWidth: Math.max(Units.gu(7), contentItem.implicitWidth + leftPadding + rightPadding)
        LuneOSButton.mainColor: LuneOSButton.blueColor

        onClicked: layoutMenu.open()

        Menu {
            id: layoutMenu

            y: -implicitHeight
            focus: false

            // Exclusive, so the tick only ever moves to another layout
            ButtonGroup {
                id: layoutGroup
            }

            Instantiator {
                model: Layouts.layouts.length
                delegate: MenuItem {
                    required property int index

                    text: Layouts.layouts[index].name
                    checkable: true
                    checked: index === keyboardBar.layoutIndex
                    ButtonGroup.group: layoutGroup
                    onTriggered: keyboardBar.layoutIndex = index
                }
                onObjectAdded: (index, object) => layoutMenu.insertItem(index, object)
                // takeItem, not removeItem: see KeyboardKey.qml
                onObjectRemoved: (index, object) => layoutMenu.takeItem(index)
            }
        }
    }

    ListView {
        id: keysView

        anchors.left: layoutSelector.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        orientation: ListView.Horizontal
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        model: keyboardBar.layout.keys
        delegate: KeyboardKey {
            required property var modelData

            height: keysView.height
            keyData: modelData
            onActivated: (action) => keyboardBar.trigger(action)
        }

        ScrollBar.horizontal: ScrollBar {
            interactive: false
        }
    }
}
