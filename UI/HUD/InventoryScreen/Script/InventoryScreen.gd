extends Control

# Currently selected item index (-1 means none selected)
var selected_index: int = -1
# Currently selected equipment slot
var selected_equip_slot: Inventory.EquipSlot
# Empty texture for holding slots shape
var empty_sprite = preload("res://UI/HUD/Textures/EmptySprite.tres")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_inventory_grid()
	populate_equipment_grid()
	
	for child in %EquipmentGrid.get_children():
		child.equip_slot_selected.connect(equip_slot_selected)
	
	for child in %InventoryGrid.get_children():
		child.gui_input.connect(
				func(event): _on_item_interact(event, child)
			)

func _on_close_button_pressed() -> void:
	hide()

func populate_inventory_grid() -> void:	
	# Clear existing textures first
	for child in %InventoryGrid.get_children():
		if child.get_node("TextureRect"):
			child.get_node("TextureRect").texture = empty_sprite
	
	# Reset selection
	selected_index = -1
	
	# Create TextureRects for each Item
	for i in range(Inventory.contents.size()):
		var item = Inventory.contents[i]
		if item and item.texture:
			var inventory_slot = %InventoryGrid.get_child(i)
			
			var texture_rect = inventory_slot.get_node("TextureRect")
			texture_rect.texture = item.texture
			
			# Add item name tooltip
			if item.has_method("get_name"):
				texture_rect.tooltip_text = item.get_name()
			
			# Create highlight child
			var highlight = ColorRect.new()
			highlight.name = "Highlight"
			highlight.color = Color(1, 1, 1, 0.3)  # Semi-transparent white
			highlight.size = Vector2(64, 64)
			highlight.visible = false
			highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			if inventory_slot.get_children().size() == 1:
				# Add highlight as child
				inventory_slot.add_child(highlight)
				highlight.anchor_right = 1.0
				highlight.anchor_bottom = 1.0
				highlight.position = Vector2.ZERO
			
			# Visual feedback for selected item
			if i == selected_index:
				inventory_slot.get_node("Highlight").visible = true  # Highlight color
			

func populate_equipment_grid() -> void:
	# Get all PanelContainers in the EquipmentGrid
	var panel_containers = %EquipmentGrid.get_children()
	
	# Iterate through each equipment slot
	for equip_slot in Inventory.EquipSlot.values():
		var slot_index: int = equip_slot as int
		
		# Safety check for array bounds
		if slot_index > panel_containers.size():
			push_error("No PanelContainer found for slot ", equip_slot)
			continue
			
		# Get the corresponding PanelContainer
		var panel = panel_containers[slot_index-1]
		
		# Find the EquipRect node (assuming it's a direct child)
		var equip_rect = panel.get_node("VBoxContainer/EquipRect") as TextureRect
		if not equip_rect:
			push_error("EquipRect not found in PanelContainer", slot_index)
			continue
			
		# Clear previous texture
		equip_rect.texture = null
		
		# Check if this slot has an equipped item
		if Inventory.equipped.has(equip_slot):
			var item = Inventory.equipped[equip_slot] as Item
			if item and item.texture:
				equip_rect.texture = item.texture
				# Optional: Set tooltip with item name
				if item.has_method("get_name"):
					equip_rect.tooltip_text = item.get_name()
			else:
				equip_rect.texture = empty_sprite
				print("Equipped item in slot ", equip_slot, " has no texture")

# Handles interaction events for inventory slots
func _on_item_interact(event: InputEvent, slot: UIInventorySlot) -> void:
	# Check if the event is a pressed mouse button
	if event is InputEventMouseButton && event.pressed:
		# Left mouse button click handling
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Debug output showing which slot was clicked
			print(slot.name + " was left-clicked")
			
			# Update the selected index (adjusting for 0-based inventory array)
			selected_index = slot.inventory_slot_index-1
			
			# Refresh the inventory display to show selection
			populate_inventory_grid()
			
			# Safety check - ensure the slot index exists in inventory
			if Inventory.contents.size() < slot.inventory_slot_index:
				return  # Exit if invalid index
			
			# Check if this item matches the currently selected equipment slot
			else:
				if Inventory.contents[slot.inventory_slot_index-1].equip_slot == selected_equip_slot:
					# Debug output and actual equipment logic
					print("Equipping " + slot.name)
					Inventory.equip_item(slot.inventory_slot_index-1, selected_equip_slot)
					
					# Refresh equipment display after change
					populate_equipment_grid()
			
func _on_visibility_changed() -> void:
	if visible:
		populate_inventory_grid()
		populate_equipment_grid()

func equip_slot_selected(equip_slot: Inventory.EquipSlot):
	selected_equip_slot = equip_slot
	
