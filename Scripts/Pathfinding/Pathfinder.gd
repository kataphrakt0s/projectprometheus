extends Node2D
class_name GridPathfinder

const GRID_SIZE := GlobalRef.GRID_SIZE

@export var grid_dimensions := Vector2i(64, 64)  # In grid cells (64x64 = 1024x1024 pixels)
@export var default_speed := 200.0
@export var debug_draw := true
@export var debug_path_color := Color.GREEN
@export var debug_path_width := 2.0
@export var debug_current_target_color := Color.RED
@export var debug_current_target_radius := 4.0

var astar_grid := AStarGrid2D.new()
var current_path: PackedVector2Array = []
var current_target_idx := 0
var is_moving := false

@onready var target_node: Node2D = get_parent()

func _ready():
	# Initialize A* grid
	astar_grid.region = Rect2i(Vector2i.ZERO, grid_dimensions)
	astar_grid.cell_size = Vector2(GRID_SIZE, GRID_SIZE)
	astar_grid.offset = Vector2.ZERO  # Origin at (0,0)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

func snap_to_grid(world_pos: Vector2) -> Vector2:
	return Vector2(
		floor(world_pos.x / GRID_SIZE) * GRID_SIZE,
		floor(world_pos.y / GRID_SIZE) * GRID_SIZE
	)

func move_to(target_world_pos: Vector2) -> bool:
	var snapped_target = snap_to_grid(target_world_pos)
	var snapped_current = snap_to_grid(target_node.global_position)
	
	# Convert to grid coordinates
	var start = Vector2i(snapped_current / Vector2(GRID_SIZE, GRID_SIZE))
	var end = Vector2i(snapped_target / Vector2(GRID_SIZE, GRID_SIZE))
	
	if not astar_grid.is_in_boundsv(start) or not astar_grid.is_in_boundsv(end):
		return false
	
	current_path = astar_grid.get_id_path(start, end)
	
	if current_path.is_empty():
		return false
	
	# Convert grid path back to world positions
	var world_path: PackedVector2Array = []
	for grid_pos in current_path:
		world_path.append(Vector2(grid_pos) * GRID_SIZE)
	
	current_path = world_path
	current_target_idx = 0
	is_moving = true
	queue_redraw()
	return true

func _process(delta):
	if not is_moving or current_path.is_empty():
		return
	
	var target_pos = current_path[current_target_idx]
	var direction = (target_pos - target_node.global_position).normalized()
	var move_distance = default_speed * delta
	
	if target_node.global_position.distance_to(target_pos) <= move_distance:
		target_node.global_position = target_pos
		current_target_idx += 1
		if current_target_idx >= current_path.size():
			is_moving = false
	else:
		target_node.global_position += direction * move_distance

# Set obstacles from world positions
func set_obstacle(world_pos: Vector2, solid: bool = true):
	var grid_pos = Vector2i(floor(world_pos.x / GRID_SIZE), floor(world_pos.y / GRID_SIZE))
	if astar_grid.is_in_boundsv(grid_pos):
		astar_grid.set_point_solid(grid_pos, solid)

# Set obstacles from TileMap
func set_obstacles_from_tilemap(tilemaplayer: TileMapLayer):
	var used_cells = tilemaplayer.get_used_cells()
	for cell in used_cells:
		var world_pos = tilemaplayer.map_to_local(cell)
		set_obstacle(world_pos)

func _draw():
	if not debug_draw or current_path.is_empty():
		return
	
	# Draw the path lines
	for i in range(current_path.size() - 1):
		var start = to_local(current_path[i])
		var end = to_local(current_path[i + 1])
		draw_line(start, end, debug_path_color, debug_path_width)
	
	# Draw current target indicator
	if is_moving and current_target_idx < current_path.size():
		var target_pos = to_local(current_path[current_target_idx])
		draw_circle(target_pos, debug_current_target_radius, debug_current_target_color)
