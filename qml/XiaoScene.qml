import QtQuick 1.1
import VPlay 1.0


Scene {
    id: scene

    property alias entitiesBar: entitiesBar
    property alias editEntityBar: editEntityBar

    gridSize: 16

    XiaoEntitiesBar {
        id: entitiesBar
        anchors {
            top: gameWindowAnchorItem.top
            left: gameWindowAnchorItem.left
            bottom: gameWindowAnchorItem.bottom
        }
        z: 1
    }

    XiaoEditEntityBar {
        id: editEntityBar
        anchors {
            top: gameWindowAnchorItem.top
            right: gameWindowAnchorItem.right
            bottom: gameWindowAnchorItem.bottom
        }
        visible: scene.state === "levelEditing"
        z: 1
    }

    onStateChanged: {
        // reset selection when state changes
        editEntityBar.entitySelected(null);
    }
}
