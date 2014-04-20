import QtQuick 1.1
import VPlay 1.0

Item {
    id: entitiesBar
    width: 125

    Rectangle {
        anchors.fill: parent
        color: "#333"
        opacity: 0.7
    }

    function init() {
        columnLoader.sourceComponent = columnComponent;
    }

    Loader {
        id: columnLoader
    }

    Component {
        id: columnComponent

        Column {
            anchors { fill: parent; leftMargin: 5; topMargin: 5; rightMargin: 5 }
            spacing: 5

            SimpleButton {
                font.pointSize: 10
                text: scene.state === "playing" ? "Game Mode" : "Edit Mode"

                onClicked: {
                    scene.state = (scene.state === "playing" ? "levelEditing" : "playing");
                }
            }

            SimpleButton {
                font.pointSize: 10
                text: "Save"
                visible: scene.state === "levelEditing"

                onClicked: {
                    levelEditor.saveCurrentLevel({
                        levelMetaData: { levelName: "landing" },
                        customData: {}
                    });
                    levelEditor.exportLevelAsFile();
                }
            }

            XiaoTabsBar {
                id: tabs
                tabs: ["Backgrounds", "Houses", "Player"]
                visible: scene.state === "levelEditing"
            }

            Item {
                id: backgrounds
                width: entitiesBar.width - 10
                height: 1
                visible: scene.state === "levelEditing" && tabs.selectedTab === "Backgrounds"

                XiaoEntityButtons {
                    entityType: "Grass"
                    imageBasename: "outdoor/grass"
                    numButtons: 5
                }

                XiaoEntityButtons {
                    entityType: "Water"
                    imageBasename: "outdoor/water"
                    numButtons: 1
                    topMargin: 100
                }

                XiaoEntityButtons {
                    entityType: "Clay"
                    imageBasename: "outdoor/clay"
                    numButtons: 1
                    topMargin: 120
                }

                XiaoEntityButtons {
                    entityType: "Rock"
                    imageBasename: "outdoor/rock"
                    numButtons: 1
                    topMargin: 140
                }

                XiaoEntityButtons {
                    entityType: "WaterGrass"
                    imageBasename: "outdoor/water-grass"
                    numButtons: 12
                    rightMargin: 20
                }

                XiaoEntityButtons {
                    entityType: "ClayGrass"
                    imageBasename: "outdoor/clay-grass"
                    numButtons: 12
                    rightMargin: 40
                }

                XiaoEntityButtons {
                    entityType: "ClayWater"
                    imageBasename: "outdoor/clay-water"
                    numButtons: 12
                    rightMargin: 60
                }

                XiaoEntityButtons {
                    entityType: "RockGrass"
                    imageBasename: "outdoor/rock-grass"
                    numButtons: 12
                    rightMargin: 80
                }

                XiaoEntityButtons {
                    entityType: "RockWater"
                    imageBasename: "outdoor/rock-water"
                    numButtons: 12
                    rightMargin: 100
                }
            }

            Item {
                id: houses
                width: entitiesBar.width - 10
                height: 1
                visible: scene.state === "levelEditing" && tabs.selectedTab === "Houses"

                XiaoEntityButton {
                    entityType: "House"
                    imageBasename: "outdoor/house"
                    width: 96
                    height: 65
                }
            }

            Item {
                id: player
                width: entitiesBar.width - 10
                height: 1
                visible: scene.state === "levelEditing" && tabs.selectedTab === "Player"

                XiaoEntityButton {
                    entityType: "Player"
                    imageBasename: "player"
                }
            }
        }
    }
}
