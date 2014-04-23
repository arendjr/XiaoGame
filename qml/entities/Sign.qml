import QtQuick 1.1
import VPlay 1.0

XiaoEntity {
    id: entity
    entityType: "Sign"
    imageBasename: "sign"
    obstacle: true
    variationType: "1"

    property string text: ""

    toStoreProperties: ["text"]

    function activate() {
        scene.showSign(entity);
    }
}
