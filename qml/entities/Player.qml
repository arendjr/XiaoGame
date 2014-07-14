import QtQuick 2.0
import VPlay 2.0

import "../lodash.js" as LoDash


XiaoEntity {
    id: entity
    entityType: "Player"
    imageBasename: "player"
    moveable: true
    variationType: "1"
    z: 5

    toStoreProperties: ["inventory"]

    property variant collidingEntities: []

    property variant inventory: ({})

    /**
     * Adds an item to the player's inventory.
     */
    function addItem(itemName, options) {
        options = options || {};

        var _ = LoDash._;

        // track the item in the player's inventory
        var inventory = _.clone(entity.inventory);
        if (_.has(inventory, itemName)) {
            inventory[itemName]++;
        } else {
            inventory[itemName] = 1;
        }
        entity.inventory = inventory;

        // and show a nice animation adding the item to the inventory button
        var item = itemManager.createItemByName(itemName, {
            x: (options.fromX || entity.x) + level.x,
            y: (options.fromY || entity.y) + level.y,
            z: 101,
            width: entity.width,
            height: entity.height
        });
        var itemAnimation = itemAnimationComponent.createObject(scene, {
            target: item,
            toX: inventoryButton.x - scene.x / scene.xScaleForScene,
            toY: inventoryButton.y - scene.y / scene.yScaleForScene,
            toSize: inventoryButton.width
        });
        itemAnimation.timeToActivate.connect(function() {
            inventoryButton.setActiveItem(item);
        });
        itemAnimation.finished.connect(function() {
            itemAnimation.destroy();
        });
        itemAnimation.start();
    }

    /**
     * Moves the player dx steps to the right, and dy steps down.
     */
    function move(dx, dy) {
        dx *= scene.gridSize;
        dy *= scene.gridSize;

        var _ = LoDash._;
        var obstacle = _.find(collidingEntities, function(collidingEntity) {
            return collidingEntity.obstacle &&
                   collidingEntity.x - entity.x === dx && collidingEntity.y - entity.y === dy;
        });
        if (obstacle) {
            if (obstacle.activate) {
                obstacle.activate(entity);
            }
        } else {
            if ((dx >= 0 || x > 0) && (dy >= 0 || y > 0) &&
                (dx <= 0 || x < level.width) && (dy <= 0 || y < level.height)) {
                x += dx;
                y += dy;

                scene.centerOnPlayer();
            }
        }
    }

    onBeginContact: {
        var otherEntity = other.parent.parent.owningEntity;
        if (otherEntity.entityType !== "Player") {
            // collidingEntities.push() doesn't seem to work (array properties are not mutable?)
            collidingEntities = collidingEntities.concat([otherEntity]);
        }
    }

    onEndContact: {
        var _ = LoDash._;
        var otherEntity = other.parent.parent.owningEntity;
        // _.without() doesn't work as the reference to otherEntity doesn't appear to be the same
        // instance as given to onBeginContact
        collidingEntities = _.reject(collidingEntities, function(collidingEntity) {
            return collidingEntity.entityId === otherEntity.entityId;
        });
    }

    Component {
        id: itemAnimationComponent

        ParallelAnimation {
            id: animation

            property variant target
            property real toX
            property real toY
            property real toSize

            signal timeToActivate()
            signal finished()

            PropertyAnimation {
                duration: 500
                easing { type: Easing.Linear }
                property: "x"
                target: animation.target
                to: animation.toX
            }
            PropertyAnimation {
                duration: 500
                easing { type: Easing.OutCubic }
                property: "y"
                target: animation.target
                to: animation.toY
            }
            PropertyAnimation {
                duration: 500
                easing { type: Easing.InCubic }
                properties: "width,height"
                target: animation.target
                to: animation.toSize
            }
            SequentialAnimation {
                PauseAnimation {
                    duration: 450
                }
                ScriptAction {
                    script: animation.timeToActivate();
                }
            }

            onRunningChanged: {
                if (!running) {
                    animation.finished();
                }
            }
        }
    }
}
