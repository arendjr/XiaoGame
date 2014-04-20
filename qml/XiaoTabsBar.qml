import QtQuick 1.1
import VPlay 1.0

Row {
    property variant tabs: []
    property string selectedTab: tabs[0]

    height: 26
    spacing: 3

    Repeater {
        model: tabs

        Rectangle {
            color: "#080"
            height: 20
            width: 6 * modelData.length // approximate text length

            Text {
                anchors.fill: parent
                color: "#fff"
                font.pointSize: 8
                text: modelData
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selectedTab = modelData;
                }
            }
        }
    }
}
