extends Node

@onready var player: Node2D = $"../DebugLevel/Player"
@onready var cursor: Node2D = $"../DebugLevel/Cursor"
@onready var terrain: Node2D = $"../DebugLevel/TestLevel/Terrain"
@onready var decor: Node2D = $"../DebugLevel/TestLevel/Decor"
@onready var tile_data: TileMapLayer = $"../DebugLevel/TestLevel/Data"
@onready var camera_2d: Camera2D = $"../DebugLevel/Player/Camera2D"
@onready var level_head_node: Node2D = $"../DebugLevel/TestLevel"

var portal_references = {}  # Dictionary: Vector2i -> Node2D

const GRID_SIZE = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for portal in get_tree().get_nodes_in_group("Portals"):
		register_portal(portal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func register_portal(portal_node: Node2D):
	var map_position = tile_data.local_to_map(portal_node.position)
	portal_references[map_position] = portal_node
