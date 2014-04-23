import QtQuick 1.1
import VPlay 1.0

Rectangle {
    id: signDisplay

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
}
