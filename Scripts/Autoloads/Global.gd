extends Node

var level_name: String = "TestLevel"

# Member variables
var portal_references = {}  # Dictionary: Vector2i -> Node2D
var HUD: CanvasLayer
var player: Node2D
var cursor: Node2D
var terrain: Node2D
var decor: Node2D
var tile_data: TileMapLayer
var camera_2d: Camera2D
var level_root_node: Node2D

const GRID_SIZE = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func register_portal(portal_node: Node2D):
	var map_position = tile_data.local_to_map(portal_node.position)
	portal_references[map_position] = portal_node

func get_portals():
	for portal in get_tree().get_nodes_in_group("Portals"):
		register_portal(portal)

func update_level() -> void:
	var base_path = "../" + level_name
	player = get_node(base_path + "/Player")
	cursor = get_node(base_path + "/Cursor")
	terrain = get_node(base_path + "/Terrain")
	decor = get_node(base_path + "/Decor")
	tile_data = get_node(base_path + "/Data")
	camera_2d = get_node(base_path + "/Player/Camera2D")
	level_root_node = get_node(base_path)
	HUD = get_node(base_path + "/HUD")
	get_portals()
