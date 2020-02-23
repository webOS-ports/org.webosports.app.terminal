import QtQuick 2.0

QtObject {
    property string initialWorkingDirectory: ""
    //property QMLTermWidget terminal: parent

    signal matchFound()
    signal noMatchFound()

    function startShellProgram() {
        console.log("starting shell...");
    }

    function sendText(command) {
        console.log("sendText: " + command);
        terminal.text += command
    }
}
