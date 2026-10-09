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

import QtQuick

import LunaNext.Common 0.1

/*
 * Turns touches on the terminal into taps, press-and-holds and swipes.
 * Mouse events pass through to the terminal underneath, which handles
 * selecting text itself.
 */
Item {
    id: inputArea

    // Distance a finger travels for one swipe step
    property real swipeDelta: Units.gu(1)

    signal touchPress(real x, real y)
    signal touchClick(real x, real y)
    signal touchPressAndHold(real x, real y)

    signal swipeYDetected(int steps)
    signal swipeXDetected(int steps)
    signal twoFingerSwipeYDetected(int steps)

    function average(p1, p2) {
        return Qt.point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
    }

    function distance(p1, p2) {
        return Math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
    }

    // Rounds towards zero, so a drag counts the same steps either way
    function truncate(value) {
        return value > 0 ? Math.floor(value) : Math.ceil(value);
    }

    MultiPointTouchArea {
        id: singleTouchArea

        // A drag only ever follows one axis; following both at once
        // misfires too easily
        readonly property int noDragging: 0
        readonly property int yDragging: 1
        readonly property int xDragging: 2

        property int dragging: noDragging
        property bool moved: false
        // Whether this gesture turned out to be a two-finger one. Decided
        // before it is handled, as switching between the two halfway goes wrong.
        property bool multiTouch: false
        property point pressPosition: Qt.point(0, 0)
        property int prevDragStepsX: 0
        property int prevDragStepsY: 0

        anchors.fill: parent
        maximumTouchPoints: 1
        mouseEnabled: false

        Timer {
            id: pressAndHoldTimer

            interval: Qt.styleHints.mousePressAndHoldInterval
            onTriggered: {
                if (!singleTouchArea.moved)
                    inputArea.touchPressAndHold(singleTouchArea.pressPosition.x,
                                                singleTouchArea.pressPosition.y);
            }
        }

        // While this runs a second finger still makes it a two-finger swipe
        Timer {
            id: multiTouchTimer

            interval: 200
        }

        onPressed: (touchPoints) => {
            const point = touchPoints[0];

            moved = false;
            multiTouch = false;
            prevDragStepsX = 0;
            prevDragStepsY = 0;
            dragging = noDragging;
            pressPosition = Qt.point(point.x, point.y);
            pressAndHoldTimer.start();
            multiTouchTimer.start();

            inputArea.touchPress(point.x, point.y);
        }

        onUpdated: (touchPoints) => {
            if (multiTouch || multiTouchTimer.running || touchPoints.length === 0)
                return;

            const point = touchPoints[0];
            const dragX = point.x - pressPosition.x;
            const dragY = point.y - pressPosition.y;
            const stepsX = inputArea.truncate(dragX / inputArea.swipeDelta);
            const stepsY = inputArea.truncate(dragY / inputArea.swipeDelta);

            if (!moved) {
                if (inputArea.distance(point, pressPosition) <= inputArea.swipeDelta)
                    return;
                moved = true;
                dragging = Math.abs(dragY) >= Math.abs(dragX) ? yDragging : xDragging;
            }

            if (dragging === yDragging && stepsY !== prevDragStepsY)
                inputArea.swipeYDetected(stepsY - prevDragStepsY);
            else if (dragging === xDragging && stepsX !== prevDragStepsX)
                inputArea.swipeXDetected(stepsX - prevDragStepsX);

            prevDragStepsX = stepsX;
            prevDragStepsY = stepsY;
        }

        onReleased: (touchPoints) => {
            const holdPending = pressAndHoldTimer.running;

            pressAndHoldTimer.stop();
            if (touchPoints.length === 0)
                return;

            if (!moved && holdPending)
                inputArea.touchClick(touchPoints[0].x, touchPoints[0].y);
        }

        MultiPointTouchArea {
            id: doubleTouchArea

            property point pressPosition: Qt.point(0, 0)
            property int prevDragSteps: 0

            anchors.fill: parent
            minimumTouchPoints: 2
            maximumTouchPoints: 2
            mouseEnabled: false

            onPressed: (touchPoints) => {
                // Too late: already taken as a one-finger swipe
                if (!multiTouchTimer.running)
                    return;

                pressPosition = inputArea.average(touchPoints[0], touchPoints[1]);
                prevDragSteps = 0;

                singleTouchArea.moved = true;
                singleTouchArea.multiTouch = true;
            }

            onUpdated: (touchPoints) => {
                // Releasing a finger can deliver an update with only one point
                if (touchPoints.length !== 2 || !singleTouchArea.multiTouch)
                    return;

                const center = inputArea.average(touchPoints[0], touchPoints[1]);
                const steps = inputArea.truncate((center.y - pressPosition.y) / inputArea.swipeDelta);

                if (steps !== prevDragSteps)
                    inputArea.twoFingerSwipeYDetected(steps - prevDragSteps);

                prevDragSteps = steps;
            }
        }
    }
}
