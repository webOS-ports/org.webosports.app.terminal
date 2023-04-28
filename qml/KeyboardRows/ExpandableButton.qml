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
import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQml.Models 2.1

import LuneOS.Components 1.0
import LunaNext.Common 0.1

Item {
    id: container

    property alias actionsModel: actionInstantiator.model
    property alias actionsDelegate: actionInstantiator.delegate
    property Action mainAction

    // Set this boolean to change the direction of the expansion. True to right and false to left.
    property bool expandRight: true

    property real animationTime: 200

    property bool expandable: true

    property int maxRows: 3
    property int _rows: Math.min(actionsModel.count, maxRows)
    property int _columns: Math.ceil(actionsModel.count / _rows)

    property int selectedIndex: -1
    property bool expanded: __expanded && expandable
    property bool __expanded: mainMouseArea.pressed && !clickTimer.running
    property bool areaPressed: mainMouseArea.pressed

    property real __maxCellWidth: Math.max(container.width, Units.gu(9))

    Instantiator {
        id: actionInstantiator
    }

    Component {
        id: repeaterDelegate
        Rectangle {
            id: delegateContainer

            property string actionText: model.text || ""
            property string actionIcon: model.icon || ""

            radius: 5
            color: "grey"
            width: __maxCellWidth
            height: container.height

            Loader {
                id: textContent
                active: delegateContainer.actionText
                sourceComponent: Button {
                    id: textButton
                    down: index == selectedIndex
                    text: delegateContainer.actionText
                    height: container.height
                    focusPolicy: Qt.NoFocus

                    Component.onCompleted: {
                        if(textButton.implicitWidth>__maxCellWidth) __maxCellWidth = textButton.implicitWidth;
                    }
                }
            }

            Loader {
                anchors.fill: parent
                scale: 0.5
                active: delegateContainer.actionIcon
                sourceComponent: Image {
                    source: delegateContainer.actionIcon
                }
            }
        }
    }

    Timer {
        id: clickTimer
        interval: 400 // TODO This interval might need tweaking.
    }

    MouseArea {
        id: mainMouseArea

        anchors.fill: expanded ? popupGridView : container
        enabled: expandable
        preventStealing: true

        onPressed: {
            if (mainAction)
                clickTimer.start();
            selectedIndex = -1;
        }

        onPositionChanged: {
            if (containsMouse && expanded) {
                var i = Math.floor(mouse.x / popupGridView.cellWidth);
                var j = _rows - Math.floor(mouse.y / popupGridView.cellHeight) - 1;
                var newIndex = i * _rows + j;
                selectedIndex =
                        (i >= 0 && j >= 0 && newIndex >= 0 && newIndex < actionsModel.count)
                            ? newIndex
                            : -1;
            }
        }

        onReleased: {
            if (clickTimer.running && mainAction)
                mainAction.trigger();
            else if (selectedIndex >= 0 && mainMouseArea.containsMouse)
                actionInstantiator.objectAt(selectedIndex).trigger();
        }
    }

    GridView {
        id: popupGridView

        height: container.height * container._rows
        width: __maxCellWidth * container._columns

        opacity: expanded ? 1.0 : 0.0

        y: -height
        x: !expandRight
           ? -__maxCellWidth * (container._columns - 1)
           : 0

        model: actionsModel
        cellHeight: container.height
        cellWidth: __maxCellWidth
        interactive: false
        delegate: repeaterDelegate

        flow: GridView.TopToBottom
        verticalLayoutDirection: GridView.BottomToTop
    }
}
