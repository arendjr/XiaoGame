import QtQuick 1.1
import VPlay 1.0

Item {
    property variant selectedEntity: null

    function entitySelected(entity) {
        if (selectedEntity) {
            selectedEntity.entityState = "";
        }

        selectedEntity = entity;
        if (selectedEntity) {
            selectedEntity.entityState = "entitySelected";
        }
    }

    id: editEntityBar
    width: 125

    Rectangle {
        anchors.fill: parent
        color: "#333"
        opacity: 0.7
    }

    Column {
        anchors { fill: parent; leftMargin: 5; topMargin: 5; rightMargin: 5 }
        spacing: 5
        visible: !!selectedEntity

        SimpleButton {
            font.pointSize: 10
            text: "Destroy"

            onClicked: {
                selectedEntity.removeEntity();
                entitySelected(null);
            }
        }
    }
}
