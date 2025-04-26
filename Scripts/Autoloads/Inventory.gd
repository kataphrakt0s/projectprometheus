extends Node

enum EquipSlot {CLOTHING1, CLOTHING2, EQUIP1, EQUIP2, HELMET, CONSUMABLE1, \
CONSUMABLE2, CONSUMABLE3}

var contents: Array[Item] # Contents of the Inventory
var equipped: Dictionary[EquipSlot, Item] # Currently Equipped Items

func add_item_to_inventory(item: Item) -> void:
	contents.append(item)

func equip_item(inventory_index: int, equipment_slot: EquipSlot) -> void:
	equipped.set(equipment_slot, contents[inventory_index])

# TODO
# Add a button that can show both currently equipped items 
# as well as the entire inventory
