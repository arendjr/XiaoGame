import QtQuick 2.0
import VPlay 2.0

XiaoEntity {
    id: entity
    entityType: "Tree"
    imageBasename: "outdoor/tree"
    obstacle: true
    variationType: "1"

    function activate(player) {
        if (variationType === "2") {
            // variationType "2" is tree with apples; pick up the apples and transform tree
            // (temporarily) into tree without apples
            player.addItem("Apple", { fromX: entity.x, fromY: entity.y });
            variationType = "1";
            timer.start();
        }
    }

    Timer {
        id: timer
        interval: 20 * 60 * 1000 // 20 min.
        running: false

        onTriggered: {
            variationType = "2";
            stop();
        }
    }
}
