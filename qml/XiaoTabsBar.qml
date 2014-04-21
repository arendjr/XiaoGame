import QtQuick 1.1
import VPlay 1.0

Flickable {
    property variant tabs: []
    property string selectedTab: tabs[0]

    clip: true
    contentWidth: row.width
    contentHeight: row.height
    height: 26

    Row {
        id: row
        height: parent.height
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
}
