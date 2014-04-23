import QtQuick 1.1
import VPlay 1.0

Clipping {
    id: entitiesBar
    width: 150

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

            XiaoTabsBar {
                id: tabs
                tabs: ["Backgrounds", "Houses", "Player", "Misc"]
                width: entitiesBar.width - 10
            }

            Item {
                height: 1
                visible: tabs.selectedTab === "Backgrounds"
                width: entitiesBar.width - 10

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
                    leftMargin: 20
                }

                XiaoEntityButtons {
                    entityType: "ClayGrass"
                    imageBasename: "outdoor/clay-grass"
                    numButtons: 12
                    leftMargin: 40
                }

                XiaoEntityButtons {
                    entityType: "ClayWater"
                    imageBasename: "outdoor/clay-water"
                    numButtons: 12
                    leftMargin: 60
                }

                XiaoEntityButtons {
                    entityType: "RockGrass"
                    imageBasename: "outdoor/rock-grass"
                    numButtons: 12
                    leftMargin: 80
                }

                XiaoEntityButtons {
                    entityType: "RockWater"
                    imageBasename: "outdoor/rock-water"
                    numButtons: 12
                    leftMargin: 100
                }
            }

            Item {
                height: 1
                visible: tabs.selectedTab === "Houses"
                width: entitiesBar.width - 10

                XiaoEntityButton {
                    entityType: "House"
                    imageBasename: "outdoor/house"
                    width: 96
                    height: 65
                }
            }

            Item {
                height: 1
                visible: tabs.selectedTab === "Player"
                width: entitiesBar.width - 10

                XiaoEntityButton {
                    entityType: "Player"
                    imageBasename: "player"
                }
            }

            Item {
                height: 1
                visible: tabs.selectedTab === "Misc"
                width: entitiesBar.width - 10

                XiaoEntityButtons {
                    entityType: "Tree"
                    imageBasename: "outdoor/tree"
                    numButtons: 2
                }

                XiaoEntityButtons {
                    entityType: "Sign"
                    imageBasename: "sign"
                    leftMargin: 20
                    numButtons: 3
                }
            }
        }
    }
}
