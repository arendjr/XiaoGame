import QtQuick 2.0
import VPlay 2.0

Rectangle {
    id: movementButton

    signal clicked

    anchors.margins: 1
    color: "#000"
    opacity: 0.2
    height: parent.height / 3 - 2
    width: parent.width / 6 - 2

    MouseArea {
        anchors.fill: parent

        onClicked: {
            movementButton.clicked();
        }
    }
}
