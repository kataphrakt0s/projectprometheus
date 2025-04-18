class_name Cursor extends Node2D

signal selection_changed(node: Selectable)

const RIGHT_CLICK_MENU = preload("res://UI/RightClickMenu/Scene/RightClickMenu.tscn")
const GRID_SIZE = GlobalRef.GRID_SIZE

var selected_node: Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var world_position = get_global_mouse_position()
			var snapped_pos = Vector2(
				floor(world_position.x / GRID_SIZE) * GRID_SIZE,
				floor(world_position.y / GRID_SIZE) * GRID_SIZE
			)
			move_cursor(snapped_pos)
			#if get_child_count() > 1:
				#var child = get_child(1)
				#child.queue_free()
				
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var world_position = get_global_mouse_position()
			var snapped_pos = Vector2(
				floor(world_position.x / GRID_SIZE) * GRID_SIZE,
				floor(world_position.y / GRID_SIZE) * GRID_SIZE
			)
			move_cursor(snapped_pos)
			if get_child_count() == 1:
				var right_click_menu = RIGHT_CLICK_MENU.instantiate()
				right_click_menu.global_position = snapped_pos - (GlobalRef.camera_2d.global_position + Vector2(-16,-16)) / 2
				add_child(right_click_menu)

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
