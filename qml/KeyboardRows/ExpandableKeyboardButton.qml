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
 * Author: Filippo Scognamiglio <flscogna@gmail.com>
 */
import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Controls.LuneOS 2.0

import LuneOS.Components 1.0
import LunaNext.Common 0.1

Item {
    id: expandableKeyboardButton
    property alias mainAction: expandableButton.mainAction
    property alias actionsModel: expandableButton.actionsModel
    property alias actionsDelegate: expandableButton.actionsDelegate
    property alias expandable: expandableButton.expandable
    property alias expandRight: expandableButton.expandRight

    property alias iconSource: innerButton.icon.source
    property alias text: innerButton.text

    width: Math.max(Units.gu(5), implicitWidth)

    ExpandableButton {
        id: expandableButton
        anchors.fill: parent

        // use an inactive button for display
        Button {
            id: innerButton
            enabled: false
            down: expandableButton.areaPressed
            anchors.fill: parent
            display: text === "" ? AbstractButton.IconOnly : AbstractButton.TextOnly
            LuneOSButton.mainColor: LuneOSButton.blueColor

            Component.onCompleted: {
                // don't grey out the button just because it is disabled
                background.opacity = 1;
            }
        }
    }
}
