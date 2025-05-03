class_name UIEquipmentSlot extends PanelContainer

@export var equip_slot: Inventory.EquipSlot

signal equip_slot_selected(equip_slot: Inventory.EquipSlot)

func _ready():
	# Enable mouse input for this PanelContainer
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print(Inventory.EquipSlot.keys()[equip_slot] + " was clicked!")
			equip_slot_selected.emit(equip_slot)
