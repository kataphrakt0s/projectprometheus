class_name Cursor extends Node2D

signal selection_changed(node: Selectable)

const RIGHT_CLICK_MENU = preload("res://UI/RightClickMenu/Scene/RightClickMenu.tscn")
const GRID_SIZE = GlobalRef.GRID_SIZE

var selected_node: Node2D

func _ready() -> void:
	TickManager.tick_advanced.connect(on_tick_advanced)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var world_position = get_global_mouse_position()
			var snapped_pos = Vector2(
				floor(world_position.x / GRID_SIZE) * GRID_SIZE,
				floor(world_position.y / GRID_SIZE) * GRID_SIZE
			)
			move_cursor(snapped_pos)
			if %PopupUI.get_child_count() > 0:
				var child = %PopupUI.get_child(0)
				child.queue_free()
				
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var world_position = get_global_mouse_position()
			var snapped_pos = Vector2(
				floor(world_position.x / GRID_SIZE) * GRID_SIZE,
				floor(world_position.y / GRID_SIZE) * GRID_SIZE
			)
			if get_child_count() == 1:
				var right_click_menu = RIGHT_CLICK_MENU.instantiate()
				add_child(right_click_menu)
				
			move_cursor(snapped_pos)
			get_child(1).reparent(%PopupUI, true)
			
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

func on_tick_advanced(_tick_count) -> void:
	select_under()
