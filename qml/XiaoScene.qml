import QtQuick 2.0
import VPlay 2.0


Scene {
    id: scene

    property alias controlsOverlay: controlsOverlay
    property alias editEntityBar: editEntityBar
    property alias entitiesBar: entitiesBar
    property alias inventoryButton: inventoryButton

    property variant player: null

    property variant activeSign: null

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
        if (state === "playing") {
            var player = scene.player;
            if (player) {
                player.move(dx, dy);
            }
        } else if (state === "sign") {
            state = "playing";
        }
    }

    /**
     * Shows the text on a sign the player is looking at.
     */
    function showSign(sign) {
        if (state === "playing") {
            activeSign = sign;
            state = "sign";
        }
    }

    gridSize: 32

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
        anchors.centerIn: parent
        height: parent.height / 2
        visible: scene.state === "sign" || scene.state === "signEditing"
        width: parent.width / 2
        z: 101
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
