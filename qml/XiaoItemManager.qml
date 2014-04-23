import QtQuick 1.1

import "XiaoItemManager.js" as XiaoItemManagerLogic


QtObject {
    id: itemManager

    property variant items: [
        "Apple"
    ]

    Component.onCompleted: {
        XiaoItemManagerLogic.init(items);
    }

    /**
     * Creates a new item by name.
     *
     * Re-uses an existing instance, if an unused one is available.
     */
    function createItemByName(itemName, properties) {
        return XiaoItemManagerLogic.createItemByName(itemName, properties);
    }
}
