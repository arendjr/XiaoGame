import QtQuick 1.1
import VPlay 1.0

Rectangle {
    id: inventoryButton

    property variant activeItem: null

    signal clicked

    x: 5
    y: 5
    height: 50
    width: 50

    color: "#8888cc"

    function setActiveItem(item) {
        if (activeItem) {
            activeItem.removeItem();
        }
        activeItem = item;

        var amount = scene.player.inventory[item.itemName];
        amountText.text = (amount > 1 ? amount : "");

        activateAnimation.start();
    }

    Rectangle {
        anchors { fill: parent; margins: 2 }
        color: "#222244"
    }

    Text {
        id: amountText
        anchors { top: parent.top; right: parent.right; margins: 2 }
        color: "#ccaa00"
        font.family: "Arial"
        text: ""
    }

    MouseArea {
        x: 0
        y: 0
        width: 60
        height: 60

        onClicked: {
            inventoryButton.clicked();
        }
    }

    SequentialAnimation {
        id: activateAnimation
        ParallelAnimation {
            PropertyAnimation {
                duration: 100
                easing { type: Easing.InOutQuad }
                properties: "width,height"
                target: inventoryButton
                to: 56
            }
            PropertyAnimation {
                duration: 100
                easing { type: Easing.InOutQuad }
                properties: "x,y"
                target: inventoryButton
                to: 2
            }
        }
        ParallelAnimation {
            PropertyAnimation {
                duration: 100
                easing { type: Easing.InOutQuad }
                properties: "width,height"
                target: inventoryButton
                to: 50
            }
            PropertyAnimation {
                duration: 100
                easing { type: Easing.InOutQuad }
                properties: "x,y"
                target: inventoryButton
                to: 5
            }
        }
    }
}
