import QtQuick 2.0
import VPlay 2.0

import "XiaoInventoryMenu.js" as XiaoInventoryMenuLogic

Rectangle {
    id: inventoryMenu

    color: "#8888cc"

    property variant __items: []

    Repeater {
        id: gridRepeater
        model: XiaoInventoryMenuLogic.NUM_CELLS

        Rectangle {
            color: "#222244"
            height: 50
            width: 50
            x: XiaoInventoryMenuLogic.getGridX(index)
            y: XiaoInventoryMenuLogic.getGridY(index)

            Text {
                anchors { top: parent.top; right: parent.right; margins: 2 }
                color: "#ccaa00"
                font.family: "Arial"
                text: ""
            }
        }
    }

    /**
     * Shows the inventory menu.
     */
    function show() {
        var items = [];
        var inventory = XiaoInventoryMenuLogic.getInventory(scene.player.inventory);
        for (var i = 0; i < XiaoInventoryMenuLogic.NUM_CELLS; i++) {
            var amountText = gridRepeater.itemAt(i).children[0];
            var inventoryItem = inventory[i];
            if (inventoryItem) {
                var item = itemManager.createItemByName(inventoryItem.itemName, {
                    x: XiaoInventoryMenuLogic.getGridX(i) + inventoryMenu.x,
                    y: XiaoInventoryMenuLogic.getGridY(i) + inventoryMenu.y,
                    width: 50,
                    height: 50
                });
                items.push(item);
                amountText.text = (inventoryItem.amount > 1 ? inventoryItem.amount : "");
            } else {
                amountText.text = "";
            }
        }

        __items = items;

        visible = true;
    }

    /**
     * Hides the inventory menu.
     */
    function hide() {
        visible = false;

        __items.forEach(function(item) {
            item.removeItem();
        });
    }
}
