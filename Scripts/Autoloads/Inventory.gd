extends Node

enum EquipSlot {NONE, AMULET, HELMET, RELIC, WEAPON, ARMOUR, OFFHAND, RING, \
BOOTS, GLOVES}

var contents: Array[Item] # Contents of the Inventory
var equipped: Dictionary[EquipSlot, Item] # Currently Equipped Items
var equipped_items: Dictionary[Item, EquipSlot]  # Reverse mapping

func add_item_to_inventory(item: Item) -> void:
	contents.append(item)

func equip_item(inventory_index: int, equipment_slot: EquipSlot) -> void:
	var item = contents[inventory_index]
	# Unequip from any existing slot first
	if equipped_items.has(item):
		equipped.erase(equipped_items[item])
	
	equipped[equipment_slot] = item
	equipped_items[item] = equipment_slot

func is_equipped(item: Item) -> bool:
	return equipped_items.has(item)
