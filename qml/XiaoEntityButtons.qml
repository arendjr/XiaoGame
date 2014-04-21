import QtQuick 1.1
import VPlay 1.0

Repeater {
    id: entityButtons

    property string imageBasename
    property string entityType: ""
    property int numButtons: 0
    property int leftMargin: 0
    property int topMargin: 0

    model: numButtons
    XiaoEntityButton {
        entityType: entityButtons.entityType
        imageBasename: entityButtons.imageBasename
        variationIndex: index
        leftMargin: entityButtons.leftMargin
        topMargin: entityButtons.topMargin
    }
}
