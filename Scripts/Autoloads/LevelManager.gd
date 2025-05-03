extends Node

signal transition_started(scene_path)
signal level_loaded(new_scene_root)
signal transition_completed

const TRANSITION_DURATION := 0.5

var _current_level: Node
var current_level_data: LevelData
var level_data: Dictionary[String, LevelData]
var _loading_screen: Control
var loading_screen_scene: PackedScene = preload("res://UI/LoadingScreen/Scene/LoadingScreen.tscn")
var tile_data: TileMapLayer
var portal_references: Dictionary[Vector2i, Node]



func _ready() -> void:
	_current_level = get_node("../Game/Level")
	current_level_data = _current_level.level_data
	level_data.set(_current_level.level_name, _current_level.level_data)
	tile_data = _current_level.get_node("Data")
	get_portals()

func change_level(new_scene_path: String) -> void:
	# Get reference to the Game node parent
	var game_node = get_node("../Game")
	if not game_node:
		push_error("Game node not found!")
		return
	
	# Get the current Level node
	var current_level = game_node.get_node("Level")
	if not current_level:
		push_error("Level node not found!")
		return
	
	# Emit transition started signal
	transition_started.emit(new_scene_path)
	
	# Show loading screen
	_show_loading_screen()
	
	# Load the new scene asynchronously
	var new_scene = load(new_scene_path) as PackedScene
	if not new_scene:
		push_error("Failed to load scene: ", new_scene_path)
		_hide_loading_screen()
		return
	
	# Create transition effect
	var tween = create_tween()
	tween.tween_property(_loading_screen, "modulate:a", 1.0, TRANSITION_DURATION/2)
	await tween.finished
	
	# Remove old level and its children
	current_level.queue_free()
	await current_level.tree_exited
	
	# Instantiate and add new level
	var new_level = new_scene.instantiate()
	game_node.add_child(new_level)
	game_node.move_child(new_level, game_node.get_children().find(current_level))
	
	# Update references
	_current_level = new_level
	if !level_data.has(_current_level.level_name):
		current_level_data = _current_level.level_data
	else:
		current_level_data = level_data.get(_current_level.level_name)
		print("Current level's containers: " + str(current_level_data.containers))
	print("Current level's containers: " + str(current_level_data.containers))
	
	tile_data = new_level.get_node("Data") as TileMapLayer
	if not tile_data:
		push_warning("New level missing TileMapLayer 'Data'")
	
	# Rebuild portal references
	portal_references.clear()
	get_portals()
	
	# Position player south of matching portal if found
	_position_player_at_exit(new_scene_path)
	
	# Complete transition
	level_loaded.emit(new_level)
	
	tween = create_tween()
	tween.tween_property(_loading_screen, "modulate:a", 0.0, TRANSITION_DURATION/2)
	await tween.finished
	_hide_loading_screen()
	
	transition_completed.emit()

func _show_loading_screen():
	if not _loading_screen:
		_loading_screen = loading_screen_scene.instantiate()
		get_tree().root.add_child(_loading_screen)
	_loading_screen.show()

func _hide_loading_screen():
	if _loading_screen:
		_loading_screen.hide()

func register_portal(portal_node: Node2D):
	portal_references = {}
	var map_position = tile_data.local_to_map(portal_node.position)
	portal_references[map_position] = portal_node
	
func get_portals():
	for portal in get_tree().get_nodes_in_group("Portals"):
		register_portal(portal)

func get_current_level_name() -> String:
	if get_tree().current_scene and get_tree().current_scene.scene_file_path:
		return get_tree().current_scene.scene_file_path.get_file()
	push_warning("Could not determine current level name!")
	return "unknown_level"

func _position_player_at_exit(entered_scene_path: String):
	var game_node = get_node("../Game")
	var player = game_node.get_node("Player")
	if not player:
		push_error("Player node not found!")
		return
	var cursor = game_node.get_node("Cursor")
	if not cursor:
		push_error("Cursor node not found!")
		return
	
	# Find portal that matches the entered scene path
	for portal_pos in portal_references:
		var portal = portal_references[portal_pos]
		if portal.from_level == entered_scene_path:
			# Calculate position one tile south (adjust GRID_SIZE as needed)
			var exit_pos = portal_pos + Vector2i(0, 1)
			var world_pos = tile_data.map_to_local(exit_pos)
			player.global_position = world_pos - Vector2(16,16)
			cursor.global_position = world_pos - Vector2(16,16)
			return
