import QtQuick

import "../qml"

Main {
    width: 480
    height: 640

    property QtObject settings: QtObject {
        property var profilesList: [
        {
          "profileVisible": "true",
          "file": "INLINE",
          "object" : {
            "id" : "simple_cmds",
            "name": "simple_cmds",
            "short_name": "Cmds",

            "buttons": [
                {
                    "main_action" : {
                        "type": "string",
                        "text" : "top",
                        "string" : "top\n"
                    }
                },
                {
                    "main_action" : {
                        "type": "string",
                        "text" : "clear",
                        "string" : "clear\n"
                    }
                },
                {
                    "main_action" : {
                        "type": "string",
                        "text" : "ls",
                        "string" : "ls\n"
                    },
                    "other_actions" : [
                        {
                            "type" : "string",
                            "text" : "-l",
                            "string" : "ls -l\n"
                        },
                        {
                            "type": "string",
                            "text": "-a",
                            "string": "ls -a\n"
                        }
                    ]
                },
                {
                    "main_action" : {
                        "type": "string",
                        "text" : "rm",
                        "string" : "rm "
                    },
                    "other_actions" : [
                        {
                            "type" : "string",
                            "text" : "-r",
                            "string" : "rm -r "
                        }
                    ]
                },
                {
                    "main_action" : {
                        "type": "string",
                        "text" : "find",
                        "string" : "find "
                    },
                    "other_actions" : [
                        {
                            "type" : "string",
                            "text" : "-name",
                            "string" : "find -name "
                        }
                    ]
                },
                {
                    "main_action" : {
                        "type": "string",
                        "text" : "chmod",
                        "string" : "chmod "
                    },
                    "other_actions" : [
                        {
                            "type" : "string",
                            "text" : "555",
                            "string" : "chmod 555 "
                        },
                        {
                            "type": "string",
                            "text": "777",
                            "string": "chmod 777 "
                        }
                    ]
                }
            ]
        }
        } ]
    }
}
