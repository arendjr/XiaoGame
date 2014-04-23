/* global _ */
Qt.include("lodash.js");


var NUM_CELLS = 42;


/**
 * Returns the X coordinate for displaying the inventory item with the given index in the grid.
 */
function getGridX(index) {

    return 2 + 51 * (index % 7);
}

/**
 * Returns the Y coordinate for displaying the inventory item with the given index in the grid.
 */
function getGridY(index) {

    return 2 + 51 * Math.floor(index / 7);
}


/**
 * Returns the inventory in a format to be displayed in the grid.
 */
function getInventory(playerInventory) {

    var inventory = _.map(playerInventory, function(amount, itemName) {
        return { amount: amount, itemName: itemName };
    });
    inventory.sort(function(a, b) {
        if (a.amount > b.amount) {
            return -1;
        } else if (a.amount < b.amount) {
            return 1;
        } else {
            return (a.itemName > b.itemName ? -1 : 1);
        }
    });
    return inventory;
}
