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
 * A stand-in for QMLTermWidget's session: no shell is started, and what the
 * app sends is kept in sent for a test to read.
 */
QtObject {
    property string initialWorkingDirectory
    property bool started: false
    property var sent: []

    signal finished()

    function startShellProgram() {
        started = true;
    }

    function sendText(text) {
        sent = sent.concat([text]);
    }
}
