import QtQuick 2.0
import VPlay 2.0

Rectangle {
    id: button

    property string text: ""

    signal clicked

    color: "#8888cc"
    height: 30
    width: 60

    Rectangle {
        anchors { fill: parent; margins: 2 }
        color: "#222244"

        Text {
            anchors.fill: parent
            font.family: "Arial"
            horizontalAlignment: Text.AlignHCenter
            text: button.text
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                button.clicked();
            }
        }
    }
}
