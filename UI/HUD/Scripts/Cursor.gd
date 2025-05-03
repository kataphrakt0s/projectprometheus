class_name Cursor
extends Node2D

# Signal emitted when cursor selects/deselects a node
# Carries the selected Selectable node (or null if nothing selected)
signal selection_changed(node: Selectable)

# Preload the right-click menu scene
const RIGHT_CLICK_MENU = preload("res://UI/RightClickMenu/Scene/RightClickMenu.tscn")
# Get grid size from global settings
const GRID_SIZE = Global.GRID_SIZE

# Currently selected node reference
var selected_node: Node2D

func _ready() -> void:
	# Connect to the tick system to update selection on game ticks
	TickManager.tick_advanced.connect(on_tick_advanced)
	
func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse input events
	if event is InputEventMouseButton and event.pressed:
		# Left click handling
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Get and snap mouse position to grid
			var world_position = get_global_mouse_position()
			var snapped_pos = Vector2(
				floor(world_position.x / GRID_SIZE) * GRID_SIZE,  # Snap X to grid
				floor(world_position.y / GRID_SIZE) * GRID_SIZE   # Snap Y to grid
			)
			# Move cursor to snapped position
			move_cursor(snapped_pos)
			
			# Remove any existing right-click menu
			if %PopupUI.get_child_count() > 0:
				var child = %PopupUI.get_child(0)
				child.queue_free()
		
		# Right click handling
		if event.button_index == MOUSE_BUTTON_RIGHT:
			# Get and snap mouse position to grid
			var world_position = get_global_mouse_position()
			var snapped_pos = Vector2(
				floor(world_position.x / GRID_SIZE) * GRID_SIZE,  # Snap X to grid
				floor(world_position.y / GRID_SIZE) * GRID_SIZE   # Snap Y to grid
			)
			# Move cursor to snapped position
			move_cursor(snapped_pos)
			
			# Create right-click menu
			create_right_click_menu()
			
			# Move menu to PopupUI layer if it exists
			if get_child(1):
				get_child(1).reparent(%PopupUI, true)

# Selects a Selectable node at current cursor position
func select_under() -> Selectable:
	# Check all Selectable nodes in the scene
	for node in get_tree().get_nodes_in_group("Selectable"):
		# If node is at cursor position, select it
		if node.global_position == self.global_position:
			selected_node = node
			return selected_node
	return null  # Return null if nothing selected

# Manually select a specific node
func select_specific(node: Node2D) -> void:
	selected_node = node
	selection_changed.emit(node)
	
# Moves cursor to target position and updates selection
func move_cursor(target_global_pos: Vector2i) -> void:
	global_position = target_global_pos
	# Check for selection at new position
	var selection = select_under()
	if selection:
		selection_changed.emit(selection)  # Emit signal with selected node
	else:
		selection_changed.emit(null)  # Emit signal with null (deselect)

# Handles selection updates when game tick advances
func on_tick_advanced(_tick_count) -> void:
	# Update selection on each game tick
	var selection = select_under()
	if selection:
		selection_changed.emit(selection)
	else:
		selection_changed.emit(null)

# Creates or refreshes the right-click menu
func create_right_click_menu() -> void:
	# If no menu exists, create one
	if %PopupUI.get_child_count() == 0:
		var right_click_menu = RIGHT_CLICK_MENU.instantiate()
		right_click_menu.scale = Vector2(0.5, 0.5)  # Scale down menu
		right_click_menu.position += Vector2(16, 0)  # Offset position
		add_child(right_click_menu)
		right_click_menu.configure_buttons()
		
	# If menu exists, replace it
	elif %PopupUI.get_child_count() == 1:
		var child = %PopupUI.get_child(0)
		child.queue_free()  # Remove existing menu
		# Create new menu instance
		var right_click_menu = RIGHT_CLICK_MENU.instantiate()
		right_click_menu.scale = Vector2(0.5, 0.5)
		right_click_menu.position += Vector2(16, 0)
		right_click_menu.configure_buttons()
		add_child(right_click_menu)
