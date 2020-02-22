import QtQuick 2.12
import QtQuick.Controls 2.4

ListModel {
    id: jsonModel

    property string filePath;

    onCountChanged: if(jsonModel.count>0) console.log("new item: " + JSON.stringify(jsonModel.get(jsonModel.count-1)));

    onFilePathChanged: if(filePath) _loadFile();

    function _loadFile() {
        console.log("Loading JSON file: " + jsonModel.filePath);
        jsonModel.clear();
        var xhr = new XMLHttpRequest;
        xhr.open("GET", filePath);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var text = xhr.responseText;
                var a = JSON.parse(xhr.responseText);
                for (var b in a) {
                    if(typeof a[b] === "object")
                        jsonModel.append(a[b])
                    else
                        jsonModel.append({"content": a[b]})
                }
            }
        }
        xhr.send();
    }
}
