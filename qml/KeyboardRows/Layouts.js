.pragma library

/*
 * The rows of extra keys the bar above the virtual keyboard can show.
 *
 * Every key either presses a key combination ("key", written as in
 * QKeySequence: modifiers joined with "+", then a Qt::Key name without the
 * "Key_") or types some text ("text"). "label" is what the button shows and
 * defaults to the combination. "more" lists alternatives offered on
 * press-and-hold, written the same way.
 */
var layouts = [
    {
        "name": "Scroll",
        "keys": [
            { "key": "PageUp", "label": "PgUp" },
            { "key": "PageDown", "label": "PgDn" },
            { "key": "Delete", "label": "Del" },
            { "key": "Home" },
            { "key": "End" },
            { "key": "Tab" },
            { "key": "Return", "label": "Enter" },
            { "key": "Up", "label": "↑" },
            { "key": "Down", "label": "↓" },
            { "key": "Left", "label": "←" },
            { "key": "Right", "label": "→" }
        ]
    },
    {
        "name": "Cmds",
        "keys": [
            { "text": "top\n", "label": "top" },
            { "text": "clear\n", "label": "clear" },
            { "text": "ls\n", "label": "ls",
              "more": [ { "text": "ls -l\n", "label": "ls -l" },
                        { "text": "ls -a\n", "label": "ls -a" } ] },
            { "text": "rm ", "label": "rm",
              "more": [ { "text": "rm -r ", "label": "rm -r" } ] },
            { "text": "find ", "label": "find",
              "more": [ { "text": "find -name ", "label": "find -name" } ] },
            { "text": "chmod ", "label": "chmod",
              "more": [ { "text": "chmod 555 ", "label": "chmod 555" },
                        { "text": "chmod 777 ", "label": "chmod 777" } ] }
        ]
    },
    {
        "name": "Fx",
        "keys": [
            { "key": "Escape", "label": "Esc" },
            { "key": "F1" }, { "key": "F2" }, { "key": "F3" }, { "key": "F4" },
            { "key": "F5" }, { "key": "F6" }, { "key": "F7" }, { "key": "F8" },
            { "key": "F9" }, { "key": "F10" }, { "key": "F11" }, { "key": "F12" }
        ]
    },
    {
        "name": "Nano",
        "keys": [
            { "key": "Ctrl+G" }, { "key": "Ctrl+O" }, { "key": "Ctrl+R" },
            { "key": "Ctrl+Y" }, { "key": "Ctrl+K" }, { "key": "Ctrl+C" },
            { "key": "Ctrl+X" }, { "key": "Ctrl+J" }, { "key": "Ctrl+W" },
            { "key": "Ctrl+V" }, { "key": "Ctrl+U" }, { "key": "Ctrl+T" }
        ]
    },
    {
        "name": "Ctrl",
        "keys": [
            { "key": "Ctrl+R" }, { "key": "Ctrl+C" }, { "key": "Ctrl+A" },
            { "key": "Ctrl+Z" }, { "key": "Ctrl+D" }
        ]
    }
];
