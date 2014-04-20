import QtQuick 1.1
import VPlay 1.0

EntityBase {
    id: entity

    width: 16
    height: 16

    property string imageBasename: ""

    property int boxX: 0
    property int boxY: 0
    property int boxWidth: width
    property int boxHeight: height

    property bool inLevelEditingMode: scene.state === "levelEditing"

    property real levelWidth: level.width
    property real levelHeight: level.height

    property alias selectionMouseArea: mouseArea

    property variant dragOffset: Qt.point(0, 0)

    property bool clickingAllowed: inLevelEditingMode

    property bool draggingAllowed: inLevelEditingMode

    property int colliderCategoriesWhileDragged: Box.All

    property int colliderCollidesWithWhileDragged: Box.All

    property real gridSize: scene.gridSize

    property bool allowedToBuild: !__outOfBoundsX && !__outOfBoundsY && !__collidingWithOthers

    property string entityState: ""

    signal entityPressed

    signal entityReleased

    signal entityClicked

    signal entityPressAndHold

    onEntityClicked: {
        if (scene.state === "levelEditing") {
            editEntityBar.entitySelected(entity);
        }
    }

    onEntityStateChanged: {
        // make sure we don't get stuck halfway an animation
        entity.opacity = 1.0;
    }

    Image {
        id: sprite
        anchors.fill: parent
        source: "../img/" + imageBasename + variationType + ".png"
    }

    MouseArea {
        id: mouseArea

        x: 0
        y: 0
        width: entity.width
        height: entity.height

        enabled: entity.clickingAllowed || entity.draggingAllowed

        drag.target: draggingAllowed ? entity : null

        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: levelWidth
        drag.maximumY: levelHeight

        onReleased: {
            releaseEntity();
        }

        onClicked: {
            clickEntity();
        }

        onPositionChanged: {
            if (drag.active) {
                entity.x += dragOffset.x;
                entity.y += dragOffset.y;
            }
            changeEntityPosition();
        }

        drag.onActiveChanged: {
            if (drag.active) {
                var entityPosition = mapToItem(entity, mouseX, mouseY);
                pressEntity(entityPosition.x, entityPosition.y);
            }
        }

        onPressAndHold: {
            entityPressAndHold();
        }
    }

    BoxCollider {
        id: collider
        x: boxX
        y: boxY
        width: boxWidth
        height: boxHeight
        collisionTestingOnlyMode: true
    }

    // a red rectangle will be shown when the entity can't be built on the position
    Rectangle {
        id: notAllowedRectangle
        color: "red"
        width: boxWidth
        height: boxHeight
        x: boxX
        y: boxY
        z: 5

        opacity: 0.5
        visible: !allowedToBuild && entityState === "entityDragged"
    }

    SequentialAnimation on opacity {
        loops: Animation.Infinite
        running: entityState === "entitySelected"
        PropertyAnimation { duration: 500; easing.type: Easing.InOutSine; to: 0.3 }
        PropertyAnimation { duration: 500; easing.type: Easing.InOutSine; to: 1.0 }
    }


    property real __maxX: levelWidth / gridSize

    property real __maxY: levelHeight / gridSize

    property bool __outOfBoundsX: false

    property bool __outOfBoundsY: false

    property bool __collidingWithOthers: false

    property int __collidingObstacles: 0

    property variant __initialColliderProperties

    property variant __initialEntityPosition

    property bool __entityPositionChanged: false


    function pressEntity(mouseX, mouseY) {
        if (!entity.draggingAllowed) {
            console.debug("EntityBaseDraggable: selectionMouseArea was pressed, but dragging is not allowed");
            return;
        }

        // initialize with false - is needed to know if entity position should get reset
        __entityPositionChanged = false;

        // dont start the dragging here, because if only pressed and shortly after again released,
        // the entity (target) position must be set here, otherwise the drag offset would not be applied correctly!
        var scenePosition = mapToItem(entity.parent, mouseX, mouseY);
        startDraggingFromScenePosition(scenePosition);
    }

    function releaseEntity() {
        if (!entity.draggingAllowed) {
            console.debug("EntityBaseDraggable: selectionMouseArea was released, but dragging is not allowed");
            return;
        }

        // restore to the initial state of the entity before dragging was started
        entityState = "";

        console.debug("EntityBaseDraggable: entityReleased position:", entity.x, entity.y, "snapped position:", snappedPose.x, snappedPose.y);

        // this must be called before the collisionTestingOnlyMode gets reset!
        // because when swithcing collisionTestingOnlyMode to false, the last position of the entity gets set to the body automatically
        // entityPositionChanged is false if the entity is clicked but not dragged, so when startDraggingFromScenePosition() was not set before
        if (allowedToBuild && __entityPositionChanged) {
            entity.x = snappedPose.x;
            entity.y = snappedPose.y;
        } else if (__initialEntityPosition) {
            entity.x = __initialEntityPosition.x;
            entity.y = __initialEntityPosition.y;
        }

        if (collider) {
            // NOTE: this is very important, because the owningEntity got overwritten!
            boxCollider.owningEntity = entity
        }
        entityReleased();
    }

    function clickEntity() {
        if (!entity.clickingAllowed) {
            console.debug("EntityBaseDraggable: selectionMouseArea was clicked, but clicking is not allowed");
            return;
        }

        entityClicked()
    }

    function changeEntityPosition() {
        if (!__entityPositionChanged) {
            __entityPositionChanged = true;
        }
    }

    Connections {
        // as an optimization, only activate listening to entity position changes while the entity is dragged
        // position-changes happen frequently, so this is a necessary optimization
        // also, position changes occur when the properties might not all be initialized leading to undefined calculations!
        target: entityState == "entityDragged" ? entity : null

        // gets called when the entity's position changes, so the snappedPose gets modified
        onXChanged: {
            var division = x / gridSize;
            var rounded = Math.round(division);
            var floored = Math.floor(division);

            var snappedPos = gridSize * (rounded > floored ? floored + 1 : floored);

            __outOfBoundsX = (rounded < 0 || rounded > __maxX);

            snappedPose.x = snappedPos;
        }

        // should be called when the entity's position changes
        onYChanged: {
            var division = y / gridSize;
            var rounded = Math.round(division);
            var floored = Math.floor(division);

            var snappedPos = gridSize * (rounded > floored ? floored + 1 : floored);

            __outOfBoundsY = (rounded < 0 || rounded > __maxY);

            snappedPose.y = snappedPos;
        }
    }

    Item {
        id: snappedPose

        property bool collidersActive: true

        width: entity.width
        height: entity.height
        rotation: entity.rotation
    }

    Item {
        BoxCollider {
            id: boxCollider
            z: 4
            width: collider.width - 2
            height: collider.height - 2
            x: collider.x + 1
            y: collider.y + 1
            collisionTestingOnlyMode: true
            categories : colliderCategoriesWhileDragged
            collidesWith : colliderCollidesWithWhileDragged
            bodyType : Body.Dynamic
            active: true
            owningEntity: entity
        }

        Connections {
            target: entityState === "entityDragged" && boxCollider.fixture || null
            onBeginContact: {
                console.debug("EntityBaseDraggable.onBeginContact called from " + boxCollider.owningEntity);
                __collidingObstacles++;
                console.debug("EntityBaseDraggable: collidingObstacles after beginContact:", __collidingObstacles);

                __collidingWithOthers = true;

                var fixture = other;
                var body = other.parent;
                var component = other.parent.parent;
                var collidedEntity = component.owningEntity;
                var collidedEntityType = collidedEntity.entityType;
                console.debug("EntityBaseDraggable: beginContact with: ", fixture, body, component, collidedEntity);
                console.debug("EntityBaseDraggable: collided entity type:", collidedEntityType);
                console.debug("allowedToBuild:", allowedToBuild, "__collidingWithOthers:", __collidingWithOthers, "__outOfBoundsX", __outOfBoundsX, "__outOfBoundsY", __outOfBoundsX)
            }
            onEndContact: {
                console.debug("EntityBaseDraggable.onEndContact");
                __collidingObstacles--;
                console.debug("EntityBaseDraggable: collidingObstacles after endContact:", __collidingObstacles);

                if (__collidingObstacles <= 0) {
                    __collidingWithOthers = false;
                    console.debug("EntityBaseDraggable: no more collision with other objects")
                } else {
                    console.debug("EntityBaseDraggable: still a collision with other object")
                }

                var fixture = other;
                var body = other.parent;
                var component = other.parent.parent;
                var collidedEntity = component.owningEntity;
                var collidedEntityType = collidedEntity.entityType;
                console.debug("EntityBaseDraggable: endContact with: ", fixture, body, component, collidedEntity);
                console.debug("EntityBaseDraggable: collided entity type:", collidedEntityType);
                //console.debug("allowedToBuild:", allowedToBuild, "__collidingWithOthers:", __collidingWithOthers, "__outOfBoundsX", __outOfBoundsX, "__outOfBoundsY", __outOfBoundsX)
            }
        }
    }

    // gets called manually by BuildEntityButton, if the button's mouseArea was pressed
    // scenePosition must have property x&y
    function startDraggingFromScenePosition(scenePosition) {
        // should be reset to guarantee it starts with counter 0 - if a collision occurs because of moving by dragOffset, an initial collision will occur so it is safe to initialize the counter here
        __collidingObstacles = 0;
        __collidingWithOthers = false;

        entityState = "entityDragged";

        // entity position is the same as body position!
        // save for restoring if building is not allowed
        __initialEntityPosition = Qt.point(entity.x, entity.y);

        // at start of draggin, position the item to the drag position and move it higher so the thumb does not obscure the tower
        //var worldCoords = mapToItem(scene, scenePosition.x+dragOffset.x, scenePosition.y+dragOffset.y);
        // no mapping is needed here! is done in onPressed or in BuildEntityButton already!
        //var worldCoords = mapToItem(scene, scenePosition.x+dragOffset.x, scenePosition.y+dragOffset.y);
        var worldCoords = Qt.point(scenePosition.x + dragOffset.x, scenePosition.y + dragOffset.y);
        entity.x = worldCoords.x;
        entity.y = worldCoords.y;

        boxCollider.owningEntity = snappedPose;

        entityPressed();
    }
}
