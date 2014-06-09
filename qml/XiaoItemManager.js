/* global _ */
Qt.include("lodash.js");


var components = {};

var instances = {};


/**
 * Initializes the item manager.
 */
function init(items) {

    console.debug("XiaoItemManager: instantiating items:", items);
    _.each(items, function(itemName) {
        var component = Qt.createComponent(Qt.resolvedUrl("items/" + itemName + ".qml"));
        components[itemName] = component;
        if (component.status === Component.Ready) {
            var instance = component.createObject(scene, {});
            if (instance) {
                console.debug("XiaoItemManager: created instance of item:", itemName);
                instances[itemName] = [instance];
            } else {
                console.log("ERROR: XiaoItemManager: Error creating instance of item:", itemName);
            }
        } else if (component.status === Component.Error) {
            console.log("ERROR: XiaoItemManager: Error loading component:", component.errorString());
        } else {
            console.log("ERROR: XiaoItemManager: Component not ready and async instantiation not supported");
        }
    });
}


/**
 * Creates a new item by name.
 *
 * Re-uses an existing instance, if an unused one is available.
 */
function createItemByName(itemName, properties) {

    if (!_.has(instances, itemName)) {
        console.log("ERROR: XiaoItemManager: Unknown item name:", itemName);
        return null;
    }

    properties = _.extend(properties, { visible: true });

    var instance = _.find(instances[itemName], { visible: false });
    if (instance) {
        console.debug("XiaoItemManager: returning unused item with name:", itemName);
        _.each(properties, function(value, key) {
            if (instance[key] !== value) {
                instance[key] = value;
            }
        });
    } else {
        console.debug("XiaoItemManager: creating new instance of item with name:", itemName);
        instance = components[itemName].createObject(scene, properties);
        instances[itemName].push(instance);
        return instance;
    }

    return instance;
}
