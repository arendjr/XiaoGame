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
     * Centers the scene view on the player.
     */
    function centerOnPlayer() {
        var levelX = scene.width / 2 - player.x - gridSize / 2;
        var levelY = scene.height / 2 - player.y - gridSize / 2;

        if (levelX > 0) {
            levelX = 0;
        }
        if (levelY > 0) {
            levelY = 0;
        }

        level.x = levelX;
        level.y = levelY;
    }

    /**
     * Initializes the scene.
     */
    function init() {
        player = entityManager.getEntityArrayByType("Player")[0];

        centerOnPlayer();
    }

    /**
     * Moves the player dx steps to the right, and dy steps down.
     */
    function movePlayer(dx, dy) {
        if (state === "playing") {
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

    Keys.onPressed: {
        var deltaX = 0, deltaY = 0;

        if (event.key === Qt.Key_Up) {
            deltaY = -1;
            event.accepted = true;
        } else if (event.key === Qt.Key_Right) {
            deltaX = 1;
            event.accepted = true;
        } else if (event.key === Qt.Key_Down) {
            deltaY = 1;
            event.accepted = true;
        } else if (event.key === Qt.Key_Left) {
            deltaX = -1;
            event.accepted = true;
        }

        if (event.modifiers & Qt.ControlModifier) {
            if (event.key === Qt.Key_E) {
                switch (state) {
                case "playing":
                    state = "levelEditing";
                    break;
                case "levelEditing":
                    state = "playing";
                    break;
                case "sign":
                    state = "signEditing";
                    break;
                case "signEditing":
                    state = "sign";
                    break;
                }
                event.accepted = true;
            } else {
                level.x += 128 * deltaX;
                level.y += 128 * deltaY;
            }
        } else {
            movePlayer(deltaX, deltaY);
        }
    }
}
