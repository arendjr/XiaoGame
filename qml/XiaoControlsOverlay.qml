import QtQuick 1.1
import VPlay 1.0

Item {
    id: controlsOverlay

    signal leftClicked
    signal upClicked
    signal rightClicked
    signal downClicked

    XiaoMovementButton {
        id: upButton
        anchors { top: parent.top; right: parent.right }

        onClicked: {
            upClicked();
        }
    }
    XiaoMovementButton {
        id: rightButton
        anchors { top: parent.top; topMargin: parent.height / 3 + 1; right: parent.right }

        onClicked: {
            rightClicked();
        }
    }
    XiaoMovementButton {
        id: downButton
        anchors { bottom: parent.bottom; right: parent.right }

        onClicked: {
            downClicked();
        }
    }
    XiaoMovementButton {
        id: leftButton
        anchors { top: parent.top; topMargin: parent.height / 3 + 1; left: parent.left }

        onClicked: {
            leftClicked();
        }
    }
}
