extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grid()
	

func _on_take_all_button_pressed() -> void:
	if Global.current_selection.item_container_data.contents.size() > 0:
		for item in Global.current_selection.item_container_data.contents:
				print("Added item to inventory: " + item.name)
				Inventory.contents.append(item as Object)
		Global.current_selection.item_container_data.contents.clear()
	else:
		print("No items left!")
	populate_grid()


func _on_close_button_pressed() -> void:
	queue_free()


func populate_grid() -> void:
	# Clear existing children first (except potential headers/backgrounds)
	for child in %GridContainer.get_children():
		if child is TextureRect:  # Only remove TextureRects
			child.queue_free()

	# Create TextureRects for each Item
	for item in Global.current_selection.item_container_data.contents:
		if item and item.texture:  # Check item exists and has texture
			var texture_rect = TextureRect.new()
			texture_rect.texture = item.texture
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			texture_rect.custom_minimum_size = Vector2(64, 64)  # Set your desired size
			
			# Optional: Add tooltip with item name
			if item.has_method("get_name"):
				texture_rect.tooltip_text = item.get_name()
			
			%GridContainer.add_child(texture_rect)
