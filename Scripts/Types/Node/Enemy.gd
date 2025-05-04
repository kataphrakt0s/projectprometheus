class_name Enemy extends Node2D

@export var health: HealthComponent
@export var enemy_data: EnemyData
@export var damage_value: float

var enemy_id: String = "" # A UID based on spawn location and parent scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_id = _generate_id()
	
	TickManager.tick_advanced.connect(_on_tick_advanced)
	
	await LevelManager.level_loaded
		
	if !LevelManager.current_level_data.enemies.has(enemy_id):
		LevelManager.current_level_data.enemies.set(enemy_id, enemy_data)
	else:
		enemy_data = LevelManager.current_level_data.enemies.get(enemy_id)
		print("Found enemy data for " + enemy_id)
		position = enemy_data.position
		
	

# TODO
# Implement state machine for basic AI logic (attacking, fleeing, moving, idle)

func _on_tick_advanced(_tick_count):
	hop_random_adjacent_square()

func _generate_id() -> String:
	var uid = "%s|%d|%d" % [
		get_parent().level_data.scene_path,
		int(global_position.x),
		int(global_position.y)
	]
	return uid

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
	
	# Attempt to attack if there is a player in the target cell
	for player in get_tree().get_nodes_in_group("Player"):
		if tilemap_cell == LevelManager.tile_data.local_to_map(player.global_position):
			is_obstacle = true
			player.get_attacked(randf(), damage_value)
	
	if not is_obstacle:
		position = target_position
		enemy_data.position = position
