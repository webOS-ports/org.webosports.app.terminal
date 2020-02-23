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

import LuneOS.Components 1.0
import LunaNext.Common 0.1

Rectangle {
    id: container

    property JsonListModel layoutModel

    // External signals.
    signal simulateSequence(var sequence, string text);
    signal simulateCommand(string command);

    color: "black"
    property color textColor


    ListView {
        id: shortcutsListView
        anchors.fill: parent
        orientation: Qt.Horizontal

        model: layoutModel
        delegate: keyDelegate
        snapMode: ListView.SnapToItem

        spacing: Units.gu(0.5)
    }

    Rectangle {
        id: scrollBar
        anchors.bottom: parent.bottom
        height: Units.dp(2)
        // FIXME
        color: "orange";

        width: shortcutsListView.visibleArea.widthRatio * shortcutsListView.width
        x: shortcutsListView.visibleArea.xPosition * shortcutsListView.width
        visible: shortcutsListView.visibleArea.widthRatio != 1.0
    }

    Component {
        id: keyDelegate
        Loader {
            id: delegateContainer
            height: shortcutsListView.height
            sourceComponent: (delegateContainer.modelActions && delegateContainer.modelActions.count > 0) ? expandable : nonExpandable

            property var actionDetails:  layoutModel.get(index)
            property var mainAction: actionDetails ? actionDetails.main_action : {}
            property var modelActions: actionDetails ? actionDetails.other_actions : {}
            property Action modelMainAction: Action {
                property string actionType: delegateContainer.mainAction.type
                text: delegateContainer.mainAction.string || ""
                shortcut: delegateContainer.mainAction.key || ""
                onTriggered: {
                    if(actionType === "key") {
                        simulateSequence(shortcut, "")
                        console.log("simulating key: " + shortcut);
                    }
                    else if(actionType === "string") {
                        simulateCommand(text);
                        console.log("simulating text: " + text);
                    }
                }
            }
            Component {
                id: nonExpandable
                KeyboardButton {
                    text: delegateContainer.mainAction.text || delegateContainer.mainAction.key || ""
                    mainAction: delegateContainer.modelMainAction
                    color: container.textColor
                }
            }
            Component {
                id: expandable
                ExpandableKeyboardButton {
                    text: delegateContainer.mainAction.text
                    mainAction: delegateContainer.modelMainAction
                    actionsModel: delegateContainer.modelActions
                    actionsDelegate: Action {
                        property string actionType: model.type
                        text: model.string || ""
                        shortcut: model.key || ""
                        onTriggered: {
                            if(actionType === "key") simulateSequence(shortcut, "")
                            else if(actionType === "string") simulateCommand(text);
                            console.log("action " + text + " has been triggered");
                        }
                    }
                    expandable: !ListView.movingHorizontally
                    expandRight: true
                    backgroundColor: container.color
                    color: container.textColor
                }
            }
        }
    }
}
