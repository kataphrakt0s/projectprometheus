extends Character

signal ui_texture_loaded(node: Selectable)

@onready var pathfinder: GridPathfinder = $Pathfinder
@onready var obstacle_tiles_layer: TileMapLayer = GlobalRef.decor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_texture = await capture_canvas_item($CharacterSprites)
	ui_texture_loaded.emit(self)
	pathfinder.set_obstacles_from_tilemap(obstacle_tiles_layer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_to(target_position: Vector2) -> bool:
	if pathfinder.move_to(target_position):
		return true
	else:
		return false
