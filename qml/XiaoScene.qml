import QtQuick 1.1
import VPlay 1.0


Scene {
    id: scene

    property alias controlsOverlay: controlsOverlay
    property alias entitiesBar: entitiesBar
    property alias editEntityBar: editEntityBar

    gridSize: 16

    XiaoControlsOverlay {
        id: controlsOverlay
        anchors.fill: gameWindowAnchorItem
        visible: scene.state === "playing"
        z: 101

        onLeftClicked: {
            movePlayer(-1, 0);
        }

        onUpClicked: {
            movePlayer(0, -1);
        }

        onRightClicked: {
            movePlayer(1, 0);
        }

        onDownClicked: {
            movePlayer(0, 1);
        }
    }

    XiaoEntitiesBar {
        id: entitiesBar
        anchors {
            top: gameWindowAnchorItem.top
            left: gameWindowAnchorItem.left
            bottom: gameWindowAnchorItem.bottom
        }
        visible: scene.state === "levelEditing"
        z: 101
    }

    XiaoEditEntityBar {
        id: editEntityBar
        anchors {
            top: gameWindowAnchorItem.top
            right: gameWindowAnchorItem.right
            bottom: gameWindowAnchorItem.bottom
        }
        visible: scene.state === "levelEditing"
        z: 101
    }

    onStateChanged: {
        // reset selection when state changes
        editEntityBar.entitySelected(null);
    }

    function movePlayer(dx, dy) {
        var player = entityManager.getEntityArrayByType("Player")[0];
        if (player) {
            player.move(dx, dy);
        }
    }
}
