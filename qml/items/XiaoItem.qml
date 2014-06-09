import QtQuick 2.0
import VPlay 2.0

Item {
    id: item

    width: 32
    height: 32
    z: 101
    visible: false

    property string itemName: ""
    property string imageBasename: ""

    Image {
        id: sprite
        anchors.fill: parent
        source: "../img/items/" + imageBasename + ".png"
    }

    /**
     * Removes an item from the scene.
     */
    function removeItem() {
        // rather than really destroying, just hide it so it can be reused by XiaoItemManager
        visible = false;
    }
}
