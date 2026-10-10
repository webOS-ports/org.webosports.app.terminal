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

Screenshot
----------

This is a screenshot taken from the desktop environment:

<img alt="Screenshot on desktop" src="https://github.com/Tofee/org.webosports.app.terminal/wiki/terminal-desktop-screenshot.png" width="250">
