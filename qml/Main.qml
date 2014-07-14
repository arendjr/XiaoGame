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
            level.width = 4096;
            level.height = 4096;

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
