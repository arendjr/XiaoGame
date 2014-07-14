import QtQuick 2.0
import VPlay 2.0

LevelBase {
    id: level

    height: 4096
    width: 4096

    Rectangle {
        color: "#8ba049"
        height: 4096
        width: 4096
    }

    PhysicsWorld {
        debugDraw.opacity: 0.2
        debugDrawVisible: false
        id: physicsWorld
        updatesPerSecondForPhysics: 30
    }
}
