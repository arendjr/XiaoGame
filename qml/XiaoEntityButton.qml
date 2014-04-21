import QtQuick 1.1
import VPlay 1.0

BuildEntityButton {
    property string imageBasename: ""
    property string entityType: ""
    property int variationIndex: 0
    property int leftMargin: 0
    property int topMargin: 0

    toCreateEntityType: "entities/" + entityType + ".qml"
    variationType: variationIndex + 1
    width: 16
    height: 16
    anchors {
        top: parent.top
        topMargin: topMargin + 20 * variationIndex
        left: parent.left
        leftMargin: leftMargin
    }

    Image {
        anchors.fill: parent
        source: "img/" + imageBasename + variationType + ".png"
    }

    onEntityWasBuilt: {
        var newEntity = entityManager.getEntityById(builtEntityId);
        editEntityBar.entitySelected(newEntity);
    }
}
