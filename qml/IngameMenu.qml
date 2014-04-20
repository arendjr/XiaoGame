import QtQuick 1.1

Column {
    spacing: 2
    anchors.centerIn: parent
    
    MenuButton {
        text: "Resume"
        onClicked: scene.state = "" // reset to default state, so hide this menu
    }
    
}

