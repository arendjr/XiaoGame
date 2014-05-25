import QtQuick 1.1
import VPlay 1.0

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
                gameWindow.forceActiveFocus();
                scene.state = "sign";
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
                gameWindow.forceActiveFocus();
                scene.state = "sign";
            }
        }
    }

    MouseArea {
        anchors.fill: scene.gameWindowAnchorItem
        z: 120

        onClicked: {
            scene.state = "playing";
        }
    }
}
