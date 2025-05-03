class_name ItemContainer
extends Selectable

# Signal emitted when the container's UI texture is loaded
signal ui_texture_loaded(node: Selectable)

@export var locked_texture: Texture2D
@export var unlocked_texture: Texture2D
@export var item_container_data: ItemContainerData
@onready var item_container_sprite: Sprite2D = $ItemContainerSprite


var chest_uid: String = ""

func _ready() -> void:
	update_texture()
	
	# Capture character sprites as a texture for UI display
	ui_texture = await capture_canvas_item(item_container_sprite)
	
	# Notify listeners that the UI texture is ready
	ui_texture_loaded.emit(self)
	
	chest_uid = _generate_id()
	
	if !LevelManager.current_level_data.containers.has(chest_uid):
		print("Not found in containers, adding now")
		LevelManager.current_level_data.containers.set(chest_uid, item_container_data)
		print("Containers data: " + str(LevelManager.current_level_data.containers))
		
	

func open() -> void:
	pass

func _generate_id() -> String:
	var uid = "%s|%d|%d" % [
		get_parent().level_data.scene_path,
		int(global_position.x),
		int(global_position.y)
	]
	print("Container ID: " + uid)
	return uid
	
func unlock() -> void:
	item_container_data.locked = false
	update_texture()
	
func lock() -> void:
	item_container_data.locked = true
	update_texture()

func update_texture() -> void:
	if item_container_data.locked:
		$ItemContainerSprite.texture = locked_texture
	else:
		$ItemContainerSprite.texture = unlocked_texture
