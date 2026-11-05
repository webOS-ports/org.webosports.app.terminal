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

import QtQuick

/*
 * A stand-in for QMLTermWidget 2.0, the C++ terminal, with the part of its
 * API the app uses. It draws a fixed screen of text in the font it is given,
 * wrapped at its width as a terminal wraps at its columns, and keeps the
 * keys it is sent in keys for a test to read.
 */
Item {
    id: widget

    property font font
    property string colorScheme
    property QtObject session

    // The screen's text; the app's own text follows it, as a shell echoes it.
    property string screen: "root@qemux86-64:~# uname -a\n"
                            + "Linux qemux86-64 6.6.0 #1 SMP PREEMPT x86_64 GNU/Linux\n"
                            + "root@qemux86-64:~# ls -l /usr/palm/applications | head -4\n"
                            + "drwxr-xr-x 3 root root 4096 Jan  1 00:00 com.palm.app.calculator\n"
                            + "drwxr-xr-x 4 root root 4096 Jan  1 00:00 org.webosports.app.camera\n"
                            + "drwxr-xr-x 3 root root 4096 Jan  1 00:00 org.webosports.app.terminal\n"
                            + "root@qemux86-64:~# "
    property var keys: []

    readonly property var fontMetrics: metrics
    readonly property int lines: Math.max(1, Math.floor(height / Math.max(1, metrics.height)))
    readonly property int columns: Math.max(1, Math.floor(width / Math.max(1, metrics.averageCharacterWidth)))
    readonly property int scrollbarMaximum: 0
    readonly property int scrollbarMinimum: 0
    readonly property int scrollbarCurrentValue: 0

    signal copyAvailable(bool available)
    signal scrollbarParamsChanged()

    FontMetrics {
        id: metrics
        font: widget.font
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Text {
        objectName: "terminalText"
        anchors.fill: parent
        color: "#ffb000"
        font: widget.font
        wrapMode: Text.WrapAnywhere
        textFormat: Text.PlainText
        text: widget.screen + (widget.session ? widget.session.sent.join("") : "") + "█"
        clip: true
    }

    function simulateKeyPress(key, modifiers, pressed, nativeScanCode, text) {
        keys = keys.concat([{ "key": key, "modifiers": modifiers }]);
    }
    function simulateWheel(x, y, buttons, modifiers, angleDelta) { scrollbarParamsChanged(); }
    function simulateMousePress(x, y, button, buttons, modifiers) {}
    function simulateMouseRelease(x, y, button, buttons, modifiers) {}
    function simulateMouseDoubleClick(x, y, button, buttons, modifiers) { copyAvailable(true); }
    function simulateMouseMove(x, y, button, buttons, modifiers) {}
    function copyClipboard() {}
    function pasteClipboard() {}
    function selectAll() { copyAvailable(true); }
}
