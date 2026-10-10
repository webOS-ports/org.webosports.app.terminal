/*
 * (c) 2026 Herman van Hazendonk <github.com@herrie.org>
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3, as published
 * by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranties of
 * MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.LuneOS

import LunaNext.Common 0.1

/*
 * One key of the bar: a tap sends its action, and when it has alternatives
 * a press-and-hold offers them in a menu.
 */
Button {
    id: keyButton

    // An entry of Layouts.js: { key | text, label, more }
    required property var keyData

    signal activated(var action)

    readonly property var alternatives: keyData.more || []

    function labelOf(action) {
        return action.label || action.key || action.text;
    }

    text: labelOf(keyData)
    focusPolicy: Qt.NoFocus
    implicitWidth: Math.max(Units.gu(6), contentItem.implicitWidth + leftPadding + rightPadding)
    LuneOSButton.mainColor: LuneOSButton.grayColor

    onClicked: activated(keyData)
    // Handling pressAndHold stops the release from clicking, so a long press
    // on a key without alternatives still has to send it
    onPressAndHold: {
        if (alternatives.length > 0)
            alternativesMenu.open();
        else
            activated(keyData);
    }

    // Tells the key with alternatives apart from the others
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: Units.gu(0.5)
        width: Units.gu(0.6)
        height: width
        radius: width / 2
        color: LuneOSButton.secondaryColor
        visible: keyButton.alternatives.length > 0
    }

    Menu {
        id: alternativesMenu

        y: -implicitHeight
        // Leave the keyboard focus with the terminal
        focus: false

        Instantiator {
            model: keyButton.alternatives
            delegate: MenuItem {
                required property var modelData

                text: keyButton.labelOf(modelData)
                onTriggered: keyButton.activated(modelData)
            }
            onObjectAdded: (index, object) => alternativesMenu.insertItem(index, object)
            // takeItem, not removeItem: the instantiator deletes its objects
            // itself, and removeItem would delete them a second time
            onObjectRemoved: (index, object) => alternativesMenu.takeItem(index)
        }
    }
}
