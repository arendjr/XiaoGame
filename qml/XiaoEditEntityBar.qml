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

    SimpleButton {
        anchors {
            left: parent.left; top: parent.top; right: parent.right
            leftMargin: 5; topMargin: 5; rightMargin: 5
        }
        font.pointSize: 10
        text: "Destroy"
        visible: !!selectedEntity

        onClicked: {
            selectedEntity.removeEntity();
            entitySelected(null);
        }
    }

    SimpleButton {
        anchors {
            left: parent.left; bottom: parent.bottom; right: parent.right
            leftMargin: 5; bottomMargin: 5; rightMargin: 5
        }
        font.pointSize: 10
        text: "Save"

        onClicked: {
            levelEditor.saveCurrentLevel({
                levelMetaData: { levelName: "landing" },
                customData: {}
            });
            levelEditor.exportLevelAsFile();
        }
    }
}
