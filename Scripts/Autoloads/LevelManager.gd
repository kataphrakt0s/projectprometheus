extends Node

signal transition_started(scene_path)
signal level_loaded(new_scene_root)
signal transition_completed

const TRANSITION_DURATION := 0.5

var _current_scene: Node
var _persistent_nodes := []
var _loading_screen: Control
var _current_load_path: String
var _is_ready := false
var loading_screen_scene: PackedScene = preload("res://UI/LoadingScreen/Scene/LoadingScreen.tscn")

func _ready() -> void:
	# Use call_deferred to safely add children during ready phase
	call_deferred("_deferred_ready")
	_current_scene = get_tree().current_scene
	_is_ready = true

func _deferred_ready() -> void:
	_loading_screen = loading_screen_scene.instantiate()
	add_child(_loading_screen)
	_loading_screen.hide()
	get_tree().root.child_entered_tree.connect(_on_scene_loaded)

func change_scene(scene_path: String, persistent_nodes: Array = []) -> void:
	if not _is_ready:
		await ready
	
	transition_started.emit(scene_path)
	_persistent_nodes = persistent_nodes
	_current_load_path = scene_path
	
	# Show loading screen
	_loading_screen.show()
	var tween = create_tween()
	tween.tween_property(_loading_screen, "modulate:a", 1.0, TRANSITION_DURATION/2)
	await tween.finished
	
	# Start loading process
	ResourceLoader.load_threaded_request(scene_path)
	
	# Progress polling
	while true:
		var status = ResourceLoader.load_threaded_get_status(scene_path)
		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				break
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				push_error("Failed to load scene: ", scene_path)
				_loading_screen.hide()
				return
				
		# Simple progress simulation (replace with actual progress tracking if available)
		await get_tree().process_frame
	
	# Complete the transition
	var new_scene = ResourceLoader.load_threaded_get(scene_path)
	await _switch_scenes(new_scene)

func _switch_scenes(new_scene: PackedScene) -> void:
	# Remove old scene but keep persistents
	for node in _persistent_nodes:
		if is_instance_valid(node) and node.is_inside_tree():
			_current_scene.remove_child(node)
	
	# Free old scene
	_current_scene.queue_free()
	await _current_scene.tree_exited
	
	# Add new scene
	var new_instance = new_scene.instantiate()
	get_tree().root.add_child(new_instance)
	Global.level_name = new_instance.name # Point to the new level node paths
	
	# Add back persistents
	for node in _persistent_nodes:
		if is_instance_valid(node):
			new_instance.add_child(node)
	
	_current_scene = new_instance
	get_tree().current_scene = _current_scene
	
	level_loaded.emit(_current_scene)
	
	# Hide loading screen
	var tween = create_tween()
	tween.tween_property(_loading_screen, "modulate:a", 0.0, TRANSITION_DURATION/2)
	await tween.finished
	_loading_screen.hide()
	
	transition_completed.emit()

func _on_scene_loaded(node: Node) -> void:
	if node != _loading_screen and node != _current_scene:
		call_deferred("_deferred_move_child", node)

func _deferred_move_child(node: Node) -> void:
	if is_instance_valid(node) and node.is_inside_tree():
		get_tree().root.move_child(node, 0)
