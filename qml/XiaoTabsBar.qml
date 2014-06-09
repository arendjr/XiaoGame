import QtQuick 2.0
import VPlay 2.0

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
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
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
