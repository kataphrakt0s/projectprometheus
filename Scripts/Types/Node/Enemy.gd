class_name Enemy extends Node2D

@export var health: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TickManager.tick_advanced.connect(_on_tick_advanced)


func _on_tick_advanced(_tick_count):
	hop_random_adjacent_square()

func hop_random_adjacent_square() -> void:
	# List possible moves (diagonal movement is not possible)
	var possible_moves: Array[Vector2] = [
		Vector2(Global.GRID_SIZE, 0),  # RIGHT
		Vector2(-Global.GRID_SIZE, 0), # LEFT
		Vector2(0, Global.GRID_SIZE),  # DOWN
		Vector2(0, -Global.GRID_SIZE)  # UP
	]

	# Get random move to attempt
	var random_move: Vector2 = possible_moves.pick_random()
	var target_position: Vector2 = position + random_move
	
	# Convert target position to tilemap coordinates for obstacle check
	var tilemap_cell := LevelManager.tile_data.local_to_map(target_position)
	
	# Check if target cell is walkable
	var cell_source_id := LevelManager.tile_data.get_cell_source_id(tilemap_cell)
	var is_obstacle := cell_source_id != -1 # -1 indicates empty cell
	
	# Do not move to the square the player currently occupies
	for player in get_tree().get_nodes_in_group("Player"):
		if tilemap_cell == LevelManager.tile_data.local_to_map(player.global_position):
			is_obstacle = true
	
	if not is_obstacle:
		position = target_position
