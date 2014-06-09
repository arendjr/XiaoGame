import QtQuick 2.0
import VPlay 2.0

Item {
    id: editEntityBar

    property variant selectedEntity: null

    property variant __propertyEditors: []

    /**
     * Selects an entity.
     */
    function selectEntity(entity) {
        if (selectedEntity) {
            selectedEntity.entityState = "";
        }

        selectedEntity = entity;
        if (selectedEntity) {
            selectedEntity.entityState = "entitySelected";
        }
    }

    width: 125

    Rectangle {
        anchors.fill: parent
        color: "#333"
        opacity: 0.7
    }

    SimpleButton {
        id: destroyButton

        anchors { left: parent.left; top: parent.top; right: parent.right; margins: 5 }
        font.pointSize: 10
        text: "Destroy"
        visible: !!selectedEntity

        onClicked: {
            selectedEntity.removeEntity();
            selectEntity(null);
        }
    }

    SimpleButton {
        id: saveButton

        anchors { left: parent.left; bottom: parent.bottom; right: parent.right; margins: 5 }
        font.pointSize: 10
        text: "Save"

        onClicked: {
            gameWindow.saveLevel();
        }
    }
}
