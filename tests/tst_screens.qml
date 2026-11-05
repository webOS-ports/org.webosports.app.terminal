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
import QtTest

import LunaNext.Common 0.1

import "../qml/KeyboardRows/Layouts.js" as Layouts

/*
 * The app - qml/Main.qml - on one screen per run (see tools/run-tests.sh):
 * the terminal with each layout of the key bar, the layout menu, a key's
 * alternatives and the edit menu, each saved as
 * build/test-output/ui/<profile>-<state>.png to look at. The terminal itself
 * is the stand-in in tests/mocks unless the runner is given a QMLTermWidget
 * build. On a screen with a notch and rounded corners (radon) the shots show
 * the parts of the panel that are not there in red.
 */
TestCase {
    id: test
    name: "Screens"
    when: windowShown

    readonly property string shotDir: decodeURIComponent(Qt.resolvedUrl("../build/test-output/ui").toString()
                                                         .replace(/^file:\/\//, ""))
    readonly property string profile: Settings.profileName
    property var app: null

    // The stand-in keeps what it was sent; the real terminal does not say.
    function fake() {
        return find("terminal").keys !== undefined;
    }

    function init_data() {
        return [{ tag: Settings.profileName + " " + Settings.displayWidth + "x" + Settings.displayHeight }];
    }

    Component {
        id: panelMask
        // What the panel does not show: the cutouts and the rounded corners.
        Canvas {
            anchors.fill: parent
            z: 100000
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.fillStyle = "rgba(255, 0, 0, 0.6)";
                var r = Settings.displayCornerRadii;
                var w = width, h = height;
                if (r.length === 4) {
                    // top left, top right, bottom right, bottom left
                    ctx.beginPath();
                    ctx.moveTo(0, 0); ctx.lineTo(r[0], 0); ctx.arc(r[0], r[0], r[0], -Math.PI / 2, Math.PI, true); ctx.closePath();
                    ctx.moveTo(w, 0); ctx.lineTo(w, r[1]); ctx.arc(w - r[1], r[1], r[1], 0, -Math.PI / 2, true); ctx.closePath();
                    ctx.moveTo(w, h); ctx.lineTo(w - r[2], h); ctx.arc(w - r[2], h - r[2], r[2], Math.PI / 2, 0, true); ctx.closePath();
                    ctx.moveTo(0, h); ctx.lineTo(0, h - r[3]); ctx.arc(r[3], h - r[3], r[3], Math.PI, Math.PI / 2, true); ctx.closePath();
                    ctx.fill();
                }
                var cuts = Settings.displayCutouts;
                for (var i = 0; i < cuts.length; i++)
                    ctx.fillRect(cuts[i].x, cuts[i].y, cuts[i].width, cuts[i].height);
            }
        }
    }

    Component {
        id: windowColour
        // The window's own colour, which a grab of its content leaves out.
        Rectangle {
            anchors.fill: parent
            z: -100000
        }
    }

    function shot(name) {
        wait(300);
        var background = windowColour.createObject(app.contentItem, { color: app.color });
        var mask = null;
        if (Settings.displayCutouts.length > 0 || Settings.displayCornerRadii.length > 0) {
            mask = panelMask.createObject(app.contentItem);
            mask.requestPaint();
            wait(100);
        }
        var done = false;
        var ok = app.contentItem.grabToImage(function(result) {
            result.saveToFile(shotDir + "/" + profile + "-" + name + ".png");
            done = true;
        });
        verify(ok, "grab " + name);
        tryVerify(function() { return done; }, 5000, "saved " + name);
        background.destroy();
        if (mask)
            mask.destroy();
    }

    function find(objectName) {
        function look(item) {
            if (!item)
                return null;
            if (item.objectName === objectName)
                return item;
            var kids = item.data || item.children || [];
            for (var i = 0; i < kids.length; i++) {
                var found = look(kids[i]);
                if (found)
                    return found;
            }
            if (item.contentItem && item.contentItem !== item)
                return look(item.contentItem);
            return null;
        }
        var it = look(app.contentItem);
        verify(it !== null, "found " + objectName);
        return it;
    }

    // The key of the bar labelled so.
    function key(label) {
        var view = find("keysView");
        for (var i = 0; i < view.contentItem.children.length; i++) {
            var k = view.contentItem.children[i];
            if (k.text === label && k.keyData !== undefined)
                return k;
        }
        fail("no key " + label);
    }

    // Shown, of some size, and wholly inside the window.
    function onScreen(item, what) {
        verify(item.visible, what + " shown");
        verify(item.width > 0 && item.height > 0, what + " has a size: " + item.width + "x" + item.height);
        var box = item.mapToItem(app.contentItem, 0, 0, item.width, item.height);
        verify(box.x >= -0.5 && box.y >= -0.5
               && box.x + box.width <= app.width + 0.5 && box.y + box.height <= app.height + 0.5,
               what + " inside the " + app.width + "x" + app.height + " window: "
               + box.x + "," + box.y + " " + box.width + "x" + box.height);
        return box;
    }

    // An open menu, inside the window.
    function menuOnScreen(menu, what) {
        tryVerify(function() { return menu.opened; }, 2000, what + " open");
        verify(menu.width > 0 && menu.height > 0, what + " has a size");
        var box = menu.contentItem.mapToItem(app.contentItem, 0, 0, menu.contentItem.width, menu.contentItem.height);
        verify(box.x >= -0.5 && box.y >= -0.5
               && box.x + box.width <= app.width + 0.5 && box.y + box.height <= app.height + 0.5,
               what + " inside the window: " + box.x + "," + box.y + " " + box.width + "x" + box.height);
        return box;
    }

    function init() {
        var component = Qt.createComponent(Qt.resolvedUrl("../qml/Main.qml"));
        if (component.status === Component.Error)
            fail(component.errorString());
        app = component.createObject(null);
        verify(app !== null, "Main.qml made");
        compare(app.width, Settings.displayWidth);
        compare(app.height, Settings.displayHeight);
        app.requestActivate();
        // A click before the window has been shown for a moment goes nowhere.
        waitForRendering(app.contentItem);
        wait(300);
    }

    function cleanup() {
        if (app) {
            app.destroy();
            app = null;
        }
        wait(50);
    }

    // The terminal above the bar, the bar at the foot, both across the window.
    function checkLayout() {
        var term = onScreen(find("terminal"), "terminal");
        var bar = onScreen(find("keyboardBar"), "key bar");
        verify(term.y + term.height <= bar.y + 0.5, "the terminal ends above the bar");
        compare(bar.y + bar.height, app.height, "the bar at the window's foot");
        compare(bar.width, app.width, "the bar across the window");
        verify(term.width >= app.width - 2 * app.cornerClearance - 0.5, "the terminal across the window");
        verify(term.height > bar.height, "the terminal is most of the window");
        var selector = onScreen(find("layoutSelector"), "layout button");
        var keys = onScreen(find("keysView"), "keys");
        verify(selector.x + selector.width <= keys.x + 0.5, "the keys after the layout button");
        if (fake())
            verify(find("terminal").columns >= 30, "room for a line: " + find("terminal").columns + " columns");
    }

    function test_layouts() {
        var bar = find("keyboardBar");
        for (var i = 0; i < Layouts.layouts.length; i++) {
            bar.layoutIndex = i;
            compare(find("layoutSelector").text, Layouts.layouts[i].name);
            var first = Layouts.layouts[i].keys[0];
            wait(50);
            var k = key(first.label || first.key || first.text);
            onScreen(k, "first key of " + Layouts.layouts[i].name);
            shot("layout-" + Layouts.layouts[i].name.toLowerCase());
            checkLayout();
        }
    }

    function test_keys_reach_the_terminal() {
        var bar = find("keyboardBar");
        bar.layoutIndex = 0;
        wait(50);
        // The first key: the others may be scrolled out of sight.
        mouseClick(key("PgUp"));
        bar.layoutIndex = 1;
        wait(50);
        mouseClick(key("ls"));
        if (!fake())
            skip("the real terminal does not say what it was sent");
        var keys = find("terminal").keys;
        compare(keys.length, 1);
        compare(keys[0].key, Qt.Key_PageUp);
        compare(find("terminal").session.sent, ["ls\n"]);
        shot("sent-ls");
    }

    function test_layout_menu() {
        mouseClick(find("layoutSelector"));
        var box = menuOnScreen(find("layoutMenu"), "layout menu");
        shot("layout-menu");
    }

    function test_alternatives() {
        find("keyboardBar").layoutIndex = 1;
        wait(50);
        var ls = key("ls");
        mousePress(ls);
        wait(Qt.styleHints.mousePressAndHoldInterval + 200);
        mouseRelease(ls);
        var menu = null;
        (function look(item) {
            var kids = item.data || [];
            for (var i = 0; i < kids.length && !menu; i++) {
                if (kids[i].objectName === "alternativesMenu")
                    menu = kids[i];
                else if (kids[i].data)
                    look(kids[i]);
            }
        })(ls);
        verify(menu !== null, "found the alternatives of ls");
        menuOnScreen(menu, "alternatives of ls");
        shot("alternatives");
    }

    function test_edit_menu() {
        var term = find("terminal");
        var x = term.width / 2, y = term.height / 3;
        // A touch: the terminal takes no mouse for its gestures.
        var touch = touchEvent(term);
        touch.press(0, term, x, y).commit();
        wait(Qt.styleHints.mousePressAndHoldInterval + 200);
        touch.release(0, term, x, y).commit();
        menuOnScreen(find("editMenu"), "edit menu");
        shot("edit-menu");
    }
}
