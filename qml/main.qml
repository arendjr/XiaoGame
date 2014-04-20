import QtQuick 1.1
import VPlay 1.0

import "lodash.js" as LoDash


GameWindow {
    activeScene: scene

    width: 960
    height: 640

    property alias entitiesBar: scene.entitiesBar
    property alias editEntityBar: scene.editEntityBar
    property alias level: levelLoader.loadedLevel

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
            console.log("loading...");
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
            Qt.resolvedUrl("entities/Water.qml"),
            Qt.resolvedUrl("entities/WaterGrass.qml")
        ]
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Up) {
            level.y -= 64;
            event.accepted = true;
        } else if (event.key === Qt.Key_Right) {
            level.x += 64;
            event.accepted = true;
        } else if (event.key === Qt.Key_Down) {
            level.y += 64;
            event.accepted = true;
        } else if (event.key === Qt.Key_Left) {
            level.x -= 64;
            event.accepted = true;
        }
    }
}
