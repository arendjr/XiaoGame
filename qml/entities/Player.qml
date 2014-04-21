import QtQuick 1.1
import VPlay 1.0

import "../lodash.js" as LoDash


XiaoEntity {
    id: entity
    entityType: "Player"
    imageBasename: "player"
    moveable: true
    variationType: "1"
    z: 5

    property variant collidingEntities: []

    function move(dx, dy) {
        dx *= scene.gridSize;
        dy *= scene.gridSize;

        var _ = LoDash._;
        if (!_.any(collidingEntities, function(collidingEntity) {
            return collidingEntity.obstacle &&
                   collidingEntity.x - entity.x === dx && collidingEntity.y - entity.y === dy;
        })) {
            x += dx;
            y += dy;
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
}
