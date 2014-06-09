import QtQuick 2.0
import VPlay 2.0

import "lodash.js" as LoDash


GameWindow {
    id: gameWindow

    activeScene: scene

    width: 960
    height: 640

    property alias controlsOverlay: scene.controlsOverlay
    property alias editEntityBar: scene.editEntityBar
    property alias entitiesBar: scene.entitiesBar
    property alias inventoryButton: scene.inventoryButton
    property alias level: levelLoader.loadedLevel

    /**
     * Saves the current level.
     */
    function saveLevel() {
        levelEditor.saveCurrentLevel({
            levelMetaData: { levelName: "landing" },
            customData: {}
        });
        levelEditor.exportLevelAsFile();
    }

    XiaoScene {
        id: scene

        width: 480
        height: 320

        state: "playing"

        LevelLoader {
            id: levelLoader
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
                    switch (scene.state) {
                    case "playing":
                        scene.state = "levelEditing";
                        break;
                    case "levelEditing":
                        scene.state = "playing";
                        break;
                    case "sign":
                        scene.state = "signEditing";
                        break;
                    case "signEditing":
                        scene.state = "sign";
                        break;
                    }
                    event.accepted = true;
                } else {
                    level.x += 64 * deltaX;
                    level.y += 64 * deltaY;
                }
            } else {
                scene.movePlayer(deltaX, deltaY);
            }
        }
    }

    LevelEditor {
        id: levelEditor

        applicationJSONLevelsDirectory: "levels/"

        levelLoader: levelLoader

        Component.onCompleted: {
            console.log("Loading levels...");
            levelEditor.loadAllLevelsFromStorageLocation(applicationJSONLevelsLocation);
        }

        onLoadAllLevelsFromStorageLocationFinished: {
            var levels = applicationJSONLevels;
            console.log(levels.length + " levels found");

            var _ = LoDash._;
            var landing = _.find(levels, { levelName: "landing" });
            levelEditor.loadSingleLevel(landing);
            //levelEditor.createNewLevel({ levelMetaData: { levelBaseUrl: "XiaoLevel.qml" } });
        }

        onLoadLevelFinished: {
            // let the scene do its own initialization
            scene.init();
            // entitiesBar must be initialized lazily, otherwise level is not available yet
            // to entityManager and BuildEntityButtons cannot instantiate entities
            entitiesBar.init();
        }
    }

    EntityManager {
        id: entityManager
        entityContainer: level

        // required for LevelEditor, so the entities can be created by entityType
        dynamicCreationEntityList: [
            Qt.resolvedUrl("entities/Clay.qml"),
            Qt.resolvedUrl("entities/ClayGrass.qml"),
            Qt.resolvedUrl("entities/ClayWater.qml"),
            Qt.resolvedUrl("entities/Grass.qml"),
            Qt.resolvedUrl("entities/House.qml"),
            Qt.resolvedUrl("entities/Player.qml"),
            Qt.resolvedUrl("entities/Rock.qml"),
            Qt.resolvedUrl("entities/RockGrass.qml"),
            Qt.resolvedUrl("entities/RockWater.qml"),
            Qt.resolvedUrl("entities/Sign.qml"),
            Qt.resolvedUrl("entities/Tree.qml"),
            Qt.resolvedUrl("entities/Water.qml"),
            Qt.resolvedUrl("entities/WaterGrass.qml")
        ]
    }

    XiaoItemManager {
        id: itemManager
    }
}
