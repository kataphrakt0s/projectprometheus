extends Character

@export var health: HealthComponent
@export var damage_value: float

@onready var player_sprite: Sprite2D = %PlayerSprite



# Movement state flag - prevents overlapping movements
var is_moving: bool = false
var facing_right: bool = false:
	set(value):
		if value == true:
			player_sprite.flip_h = true
		else:
			player_sprite.flip_h = false
		facing_right = value


func _ready() -> void:
	LevelManager.transition_started.connect(_level_transition_started)
	
	# Connect to level manager's transition complete signal
	LevelManager.transition_completed.connect(_on_level_ready)
	
	%HUD.get_node("HUD").debug_update_player_hp(health.current_hit_points)
	
# Process loop - handles movement input when not already moving
func _process(_delta: float) -> void:
	if not is_moving:
		handle_movement_input()
	
	if Input.is_action_just_pressed("open_inventory"):
		var inventory_screen = %HUD.get_node("HUD/InventoryScreen")
		inventory_screen.visible = !inventory_screen.visible

# Handles keyboard input for character movement
func handle_movement_input() -> void:
	# Check each movement direction for key presses
	if Input.is_action_just_pressed("move_right"):
		attempt_move(Vector2.RIGHT)
		facing_right = true
	elif Input.is_action_just_pressed("move_left"):
		attempt_move(Vector2.LEFT)
		facing_right = false
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
	var tilemap_cell := LevelManager.tile_data.local_to_map(target_position)
	
	# Check for portal at target position
	if LevelManager.portal_references.has(tilemap_cell):
		var portal = LevelManager.portal_references[tilemap_cell]
		if !portal.locked:
			portal.activate()
		else:
			portal.unlock()
			
		
	# Check if target cell is walkable (empty or portal)
	var cell_source_id := LevelManager.tile_data.get_cell_source_id(tilemap_cell)
	var is_obstacle := cell_source_id != -1 # -1 indicates empty cell
	
	# Check for enemy at target position, enemies are unwalkable
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if tilemap_cell == LevelManager.tile_data.local_to_map(enemy.global_position):
			print("Cannot move onto Enemy square")
			is_obstacle = true
	
	# If no obstacle, move to target position
	if not is_obstacle:
		is_moving = true
		position = target_position
		EventBus.advance_tick_requested.emit()	
		is_moving = false
		
func get_attacked(roll: float, damage_value: float) -> void:
	var player_roll = randf()
	if player_roll < roll:
		print("You were hit for " + str(damage_value) + " damage!")
		health.take_damage(damage_value)
		%HUD.get_node("HUD").debug_update_player_hp(health.current_hit_points)
	else:
		print("An enemy missed an attack on you!")
		

func attack(enemy: Enemy, damage_value: float, roll: float = randf()) -> void:
	if randf() < roll:
		enemy.health.take_damage(damage_value)
	else:
		print("Attack missed!")

# Callback when a new level has finished loading
func _on_level_ready():
	is_moving = false
	
	# Re-capture character sprites for UI (in case of level changes)
	#ui_texture = await capture_canvas_item($CharacterSprites)
	
	# Notify that the UI texture has been updated
	#ui_texture_loaded.emit(self)

func _level_transition_started(_scene_path):
	is_moving = true
	
# DEPRECATED
#func move_to(target_position: Vector2) -> bool:
	#if pathfinder.move_to(target_position):
		#return true
	#else:
		#return false
