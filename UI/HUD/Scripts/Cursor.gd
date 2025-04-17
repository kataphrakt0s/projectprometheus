class_name Cursor extends Node2D

signal selection_changed(node: Selectable)

var selected_node: Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var world_position = get_global_mouse_position()
			var snapped_pos = Vector2(
				floor(world_position.x / 16) * 16,
				floor(world_position.y / 16) * 16
			)
			move_cursor(snapped_pos)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var world_position = get_global_mouse_position()
			if Actors.player.move_to(world_position):
				print("Moving")
			else:
				print("Failed to move")

func select_under() -> Selectable:
	for node in get_tree().get_nodes_in_group("Selectable"):
		if node.global_position == self.global_position:
			selected_node = node
			return selected_node
	return null

func select_specific(node: Node2D) -> void:
	selected_node = node
	
func move_cursor(target_global_pos: Vector2i) -> void:
	global_position = target_global_pos
	var selection = select_under()
	print(selection)
	if selection:
		selection_changed.emit(selection)
	else:
		selection_changed.emit(null)
