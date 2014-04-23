import QtQuick 1.1
import VPlay 1.0


Scene {
    id: scene

    property alias controlsOverlay: controlsOverlay
    property alias editEntityBar: editEntityBar
    property alias entitiesBar: entitiesBar
    property alias inventoryButton: inventoryButton

    property variant player: null

    /**
     * Initializes the scene.
     */
    function init() {
        player = entityManager.getEntityArrayByType("Player")[0];
    }

    /**
     * Moves the player dx steps to the right, and dy steps down.
     */
    function movePlayer(dx, dy) {
        if (scene.state === "playing") {
            var player = scene.player;
            if (player) {
                player.move(dx, dy);
            }
        }
    }

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

    XiaoInventoryButton {
        id: inventoryButton
        visible: scene.state === "playing" || scene.state === "inventory"
        z: 101

        onClicked: {
            if (scene.state === "playing") {
                scene.state = "inventory";
            } else {
                scene.state = "playing";
            }
        }
    }

    XiaoInventoryMenu {
        id: inventoryMenu
        anchors { fill: parent; topMargin: 5; rightMargin: 60; bottomMargin: 5; leftMargin: 60 }
        z: 101
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

    XiaoSignDisplay {
        id: signDisplay
        visible: scene.state === "sign"
    }

    onStateChanged: {
        if (state === "inventory") {
            inventoryMenu.show();
        } else {
            inventoryMenu.hide();

            // reset selection when state changes
            editEntityBar.selectEntity(null);
        }
    }
}
