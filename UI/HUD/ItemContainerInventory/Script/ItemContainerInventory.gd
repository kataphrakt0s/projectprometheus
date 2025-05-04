extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grid()  # Initialize the grid display when the UI opens


# Handles the "Take All" button press action
func _on_take_all_button_pressed() -> void:
	# Check if container has items
	if Global.current_selection.item_container_data.contents.size() > 0:
		# Transfer all items to inventory
		for item in Global.current_selection.item_container_data.contents:
			print("Added item to inventory: " + item.name)
			Inventory.contents.append(item as Object)
		
		# Clear the container after taking all items
		Global.current_selection.item_container_data.contents.clear()
	else:
		print("No items left!")  # Feedback for empty container
	
	# Refresh the grid display
	populate_grid()


# Closes the container UI when the close button is pressed
func _on_close_button_pressed() -> void:
	queue_free()  # Remove this UI from the scene


# Populates the grid with items from the current container
func populate_grid() -> void:
	# Clear existing item displays (only TextureRects)
	for child in %GridContainer.get_children():
		if child is TextureRect:  # Only remove item displays, not other UI elements
			child.queue_free()

	# Create display for each item in container
	for i in Global.current_selection.item_container_data.contents.size():
		var item = Global.current_selection.item_container_data.contents[i]
		
		# Only proceed if item exists and has a texture
		if item and item.texture:
			# Create new item display
			var texture_rect = TextureRect.new()
			texture_rect.texture = item.texture
			
			# Configure display properties
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			texture_rect.custom_minimum_size = Vector2(64, 64)  # Uniform item size
			
			# Connect click handler with item context
			texture_rect.gui_input.connect(
				func(event): on_item_clicked(event, item, Global.current_selection, i)
			)
			
			# Hover feedback
			texture_rect.mouse_entered.connect(func(): texture_rect.modulate = Color.GREEN_YELLOW)
			texture_rect.mouse_exited.connect(func(): texture_rect.modulate = Color.WHITE)
			
			# Add tooltip if available
			if item.has_method("get_name"):
				texture_rect.tooltip_text = item.get_name()
			
			# Add to grid
			%GridContainer.add_child(texture_rect)


# Handles clicks on individual items
func on_item_clicked(event: InputEvent, item: Item, container: ItemContainer, item_index: int):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Transfer single item to inventory
			print("Added " + str(item) + " to inventory")
			Inventory.add_item_to_inventory(item)
			
			# Remove from container and refresh display
			container.item_container_data.contents.remove_at(item_index)
			populate_grid()
