extends Character

signal ui_texture_loaded(node: Selectable)

@onready var obstacle_tiles_layer: TileMapLayer = GlobalRef.decor
var is_moving: bool = false

func _ready() -> void:
	ui_texture = await capture_canvas_item($CharacterSprites)
	ui_texture_loaded.emit(self)

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
		floor(position.x / GlobalRef.GRID_SIZE),
		floor(position.y / GlobalRef.GRID_SIZE)
	)
	
	var target_cell := current_cell + direction
	var target_position := target_cell * GlobalRef.GRID_SIZE
	
	# Convert target cell to tilemap coordinates for obstacle check
	var tilemap_cell := obstacle_tiles_layer.local_to_map(target_position)
	
	# Check if target cell is walkable (empty)
	if obstacle_tiles_layer.get_cell_source_id(tilemap_cell) == -1:  # -1 means empty cell
		is_moving = true
		position = target_position
		
		# Advance game tick every time the player moves
		EventBus.advance_tick_requested.emit()
		
		is_moving = false

# DEPRECATED
#func move_to(target_position: Vector2) -> bool:
	#if pathfinder.move_to(target_position):
		#return true
	#else:
		#return false
