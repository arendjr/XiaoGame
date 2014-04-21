import QtQuick 1.1
import VPlay 1.0

LevelBase {
    id: level

    Rectangle {
        color: "#8ba049"
        height: 4096
        width: 4096
    }

    PhysicsWorld {
        debugDraw.opacity: 0.2
        id: physicsWorld
        updatesPerSecondForPhysics: 60
    }
}
