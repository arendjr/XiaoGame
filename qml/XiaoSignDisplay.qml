import QtQuick 2.0
import VPlay 2.0

Rectangle {
    id: signDisplay

    color: "#cc8888"

    Rectangle {
        anchors { fill: parent; margins: 2 }
        color: "#442222"

        Text {
            anchors.fill: parent
            color: "#ffffcc"
            font.family: "Arial"
            horizontalAlignment: Text.AlignHCenter
            text: scene.activeSign ? scene.activeSign.text : ""
            verticalAlignment: Text.AlignVCenter
            visible: scene.state === "sign"
        }

        TextEdit {
            id: textEdit

            anchors { fill: parent; bottomMargin: 36 }
            color: "#ffffcc"
            focus: true
            font.family: "Arial"
            text: scene.activeSign ? scene.activeSign.text : ""
            visible: scene.state === "signEditing"
        }

        XiaoButton {
            anchors { left: parent.left; bottom: parent.bottom; margins: 3 }
            text: "Cancel"
            visible: scene.state === "signEditing"
            width: parent.width / 2 - 6

            onClicked: {
                textEdit.text = scene.activeSign.text;
                scene.state = "sign";
                scene.focus = true;
            }
        }

        XiaoButton {
            anchors { right: parent.right; bottom: parent.bottom; margins: 3 }
            text: "Save"
            visible: scene.state === "signEditing"
            width: parent.width / 2 - 6

            onClicked: {
                scene.activeSign.text = textEdit.text;
                gameWindow.saveLevel();
                scene.state = "sign";
                scene.focus = true;
            }
        }
    }
}
