extends Character

# Signal emitted when the character's UI texture is loaded
# Carries the Selectable node reference
signal ui_texture_loaded(node: Selectable)

# Movement state flag - prevents overlapping movements
var is_moving: bool = false


func _ready() -> void:
	# Capture character sprites as a texture for UI display
	ui_texture = await capture_canvas_item($CharacterSprites)
	
	# Notify listeners that the UI texture is ready
	ui_texture_loaded.emit(self)
	
	# Connect to level manager's transition complete signal
	LevelManager.transition_completed.connect(_on_level_ready)
	
# Process loop - handles movement input when not already moving
func _process(_delta: float) -> void:
	if not is_moving:
		handle_movement_input()

# Handles keyboard input for character movement
func handle_movement_input() -> void:
	# Check each movement direction for key presses
	if Input.is_action_just_pressed("move_right"):
		attempt_move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("move_left"):
		attempt_move(Vector2.LEFT)
	elif Input.is_action_just_pressed("move_down"):
		attempt_move(Vector2.DOWN)
	elif Input.is_action_just_pressed("move_up"):
		attempt_move(Vector2.UP)

# Attempts to move the character in the specified grid direction
func attempt_move(direction: Vector2) -> void:
	# Calculate current cell position based on top-left origin
	var current_cell := Vector2(
		floor(position.x / Global.GRID_SIZE), # X grid coordinate
		floor(position.y / Global.GRID_SIZE)  # Y grid coordinate
	)
	
	# Calculate target grid position and world position
	var target_cell := current_cell + direction
	var target_position := target_cell * Global.GRID_SIZE
	
	# Convert target cell to tilemap coordinates for obstacle check
	var tilemap_cell := Global.tile_data.local_to_map(target_position)
	
	# Check for portal at target position
	if Global.portal_references.has(tilemap_cell):
		var portal = Global.portal_references[tilemap_cell]
		if !portal.locked:
			portal.activate()
		else:
			portal.unlock()
			
	
		
	# Check if target cell is walkable (empty or portal)
	var cell_source_id := Global.tile_data.get_cell_source_id(tilemap_cell)
	var is_obstacle := cell_source_id != -1 # -1 indicates empty cell
	
	# If no obstacle, move to target position
	if not is_obstacle:
		is_moving = true
		position = target_position
		EventBus.advance_tick_requested.emit()	
		is_moving = false	
		
# Callback when a new level has finished loading
func _on_level_ready():
	# Re-capture character sprites for UI (in case of level changes)
	ui_texture = await capture_canvas_item($CharacterSprites)
	
	# Notify that the UI texture has been updated
	ui_texture_loaded.emit(self)

# Update the character sprite with the correct equipment textures
func update_displayed_equipment() -> void:
	%Clothing1Sprite.texture = \
	Inventory.equipped.get(Inventory.EquipSlot.CLOTHING1).texture
	
	%Clothing2Sprite.texture = \
	Inventory.equipped.get(Inventory.EquipSlot.CLOTHING2).texture
	
	%Equipment1Sprite.texture = \
	Inventory.equipped.get(Inventory.EquipSlot.EQUIP1).texture
	
	%Equipment2Sprite.texture = \
	Inventory.equipped.get(Inventory.EquipSlot.EQUIP2).texture
	
	%HelmetSprite.texture = \
	Inventory.equipped.get(Inventory.EquipSlot.HELMET).texture
	
	# Re-capture character sprites for UI (in case of equipment changes)
	ui_texture = await capture_canvas_item($CharacterSprites)
	
	# Notify that the UI texture has been updated
	ui_texture_loaded.emit(self)
	
# DEPRECATED
#func move_to(target_position: Vector2) -> bool:
	#if pathfinder.move_to(target_position):
		#return true
	#else:
		#return false
