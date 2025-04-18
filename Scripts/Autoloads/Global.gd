extends Node

@onready var player: Node2D = $"../TestLevel/Player"
@onready var cursor: Node2D = $"../TestLevel/Cursor"
@onready var terrain: Node2D = $"../TestLevel/Terrain"
@onready var decor: Node2D = $"../TestLevel/Decor"
@onready var camera_2d: Camera2D = $"../TestLevel/Player/Camera2D"

const GRID_SIZE = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
