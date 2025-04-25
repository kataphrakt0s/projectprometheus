class_name Cursor extends Node2D

signal selection_changed(node: Selectable)

const RIGHT_CLICK_MENU = preload("res://UI/RightClickMenu/Scene/RightClickMenu.tscn")
const GRID_SIZE = Global.GRID_SIZE

var selected_node: Node2D

func _ready() -> void:
	TickManager.tick_advanced.connect(on_tick_advanced)
	
func _unhandled_input(event: InputEvent) -> void:
	# Move cursor and close right click menu
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var world_position = get_global_mouse_position()
			var snapped_pos = Vector2(
				floor(world_position.x / GRID_SIZE) * GRID_SIZE,
				floor(world_position.y / GRID_SIZE) * GRID_SIZE
			)
			move_cursor(snapped_pos)
			
			# Remove right click menu
			if %PopupUI.get_child_count() > 0:
				var child = %PopupUI.get_child(0)
				child.queue_free()
		
		# Move cursor and create right click menu
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var world_position = get_global_mouse_position()
			var snapped_pos = Vector2(
				floor(world_position.x / GRID_SIZE) * GRID_SIZE,
				floor(world_position.y / GRID_SIZE) * GRID_SIZE
			)
			create_right_click_menu()
				
			move_cursor(snapped_pos)
			# Reparent right click menu to popup UI
			if get_child(1):
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
	if selection:
		selection_changed.emit(selection)
	else:
		selection_changed.emit(null)

func on_tick_advanced(_tick_count) -> void:
	var selection = select_under()
	if selection:
		selection_changed.emit(selection)
	else:
		selection_changed.emit(null)

func create_right_click_menu() -> void:
	if %PopupUI.get_child_count() == 0:
		var right_click_menu = RIGHT_CLICK_MENU.instantiate()
		right_click_menu.scale = Vector2(0.5, 0.5)
		right_click_menu.position += Vector2(16, 0)
		add_child(right_click_menu)
	elif %PopupUI.get_child_count() == 1:
		var child = %PopupUI.get_child(0)
		child.queue_free()
		var right_click_menu = RIGHT_CLICK_MENU.instantiate()
		right_click_menu.scale = Vector2(0.5, 0.5)
		right_click_menu.position += Vector2(16, 0)
		add_child(right_click_menu)
