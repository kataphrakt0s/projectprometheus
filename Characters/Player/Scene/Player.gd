extends Character

signal ui_texture_loaded(node: Selectable)

var is_moving: bool = false


func _ready() -> void:
	ui_texture = await capture_canvas_item($CharacterSprites)
	ui_texture_loaded.emit(self)
	LevelManager.transition_completed.connect(_on_level_ready)

func _process(_delta: float) -> void:
	if not is_moving:
		handle_movement_input()

func handle_movement_input() -> void:
	if Input.is_action_just_pressed("move_right"):
		attempt_move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("move_left"):
		attempt_move(Vector2.LEFT)
	elif Input.is_action_just_pressed("move_down"):
		attempt_move(Vector2.DOWN)
	elif Input.is_action_just_pressed("move_up"):
		attempt_move(Vector2.UP)

func attempt_move(direction: Vector2) -> void:
	# Calculate current cell position based on top-left origin
	var current_cell := Vector2(
		floor(position.x / Global.GRID_SIZE),
		floor(position.y / Global.GRID_SIZE)
	)
	
	var target_cell := current_cell + direction
	var target_position := target_cell * Global.GRID_SIZE
	
	# Convert target cell to tilemap coordinates for obstacle check
	var tilemap_cell := Global.tile_data.local_to_map(target_position)
	
	if Global.portal_references.has(tilemap_cell):
		var portal = Global.portal_references[tilemap_cell]
		if !portal.locked:
			print("portal")
			portal.activate()
		else:
			print("portal locked")
			portal.unlock()
		
	# Check if target cell is walkable (empty or portal)
	var cell_source_id := Global.tile_data.get_cell_source_id(tilemap_cell)
	var is_obstacle := cell_source_id != -1
		
	if not is_obstacle:
		is_moving = true
		position = target_position
		EventBus.advance_tick_requested.emit()	
		is_moving = false	

func _on_level_ready():
	print("New level fully loaded and visible")
	ui_texture = await capture_canvas_item($CharacterSprites)
	ui_texture_loaded.emit(self)
	
# DEPRECATED
#func move_to(target_position: Vector2) -> bool:
	#if pathfinder.move_to(target_position):
		#return true
	#else:
		#return false
