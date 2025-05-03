class_name ItemContainer
extends Selectable

signal container_opened(persistent_id: String)
signal contents_changed  # Emitted when items are added/removed

@export var locked_texture: Texture2D
@export var unlocked_texture: Texture2D
@export var locked := true

var persistent_id: String = ""  # Set in _ready()
var is_opened := false
var contents: Array[Item] = []:  
	set(value):
		contents = value
		contents_changed.emit()

func _ready() -> void:
	persistent_id = _generate_persistent_id()
	update_texture()

func open() -> void:
	if !locked and !is_opened:
		is_opened = true
		container_opened.emit(persistent_id)
		update_texture()

func _generate_persistent_id() -> String:
	return "%s|%d|%d" % [
		get_tree().current_scene.scene_file_path.get_file(),
		int(global_position.x),
		int(global_position.y)
	]
	
func unlock() -> void:
	locked = false
	update_texture()
	
func lock() -> void:
	locked = true
	update_texture()

func update_texture() -> void:
	if locked:
		$ItemContainerSprite.texture = locked_texture
	else:
		$ItemContainerSprite.texture = unlocked_texture
