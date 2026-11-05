LuneOS Terminal
==================

Terminal app for LuneOS.

Summary
-------
This project is a simple terminal app for LuneOS.

Description
-----------
This project is a simple terminal app for LuneOS.
It uses QMLTermWidget 2.0, the Qt 6 QML port of QTermWidget from
https://github.com/Swordfish90/qmltermwidget, and the LuneOS controls style
and LunaNext.Common from luneos-components.

Above the virtual keyboard a bar offers the keys a phone keyboard lacks
(Ctrl, Esc, arrows, function keys) and some ready-made commands; the button on
its left picks the layout. Keys with a dot offer alternatives on
press-and-hold. The layouts live in `qml/KeyboardRows/Layouts.js`.

On the terminal itself one finger walks the cursor and the shell history, two
fingers scroll back, and press-and-hold opens Copy and Paste.

Running on the desktop
----------------------
`main-desktop.qmlproject` expects these next to this checkout:

* `../qmltermwidget`: a QMLTermWidget 2.0 build (`qmake6 && make` in the
  checkout puts the module in `QMLTermWidget/`)
* `../luneos-components`: with the LuneOS style plugin built, for
  `modules/`, and its desktop stubs in `test/imports`

Tests
-----
On the build host, with luneos-components checked out next to this
checkout:

    tools/run-tests.sh [path to luneos-components]

runs `tests/tst_screens.qml`: the app with each layout of the key bar, the
layout menu, a key's alternatives and the edit menu, at each screen in
`PROFILES` - by default `mindphone` (480x800), `q25` (720x720), `tp`
(1024x768) and `radon` (720x1600, with a notch and rounded corners, drawn
over in red in its shots). It checks that the terminal fills the window
above the bar, that the bar runs across its foot with the layout button and
the first key on the screen, that the menus open inside the window, and
that a key reaches the terminal. Each state is saved as
`build/test-output/ui/<profile>-<state>.png`.

The terminal is the QML stand-in in `tests/mocks/QMLTermWidget`, which
starts no shell and shows a fixed screen of text. With
`QMLTERMWIDGET=<folder holding a QMLTermWidget/ build>` the real one is
used instead: a shell then runs in `$HOME`, and the test that reads what
the terminal was sent is skipped.

Screenshot
----------

This is a screenshot taken from the desktop environment:

<img alt="Screenshot on desktop" src="https://github.com/Tofee/org.webosports.app.terminal/wiki/terminal-desktop-screenshot.png" width="250">
