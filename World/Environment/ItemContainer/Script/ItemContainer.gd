class_name ItemContainer
extends Selectable

@export var locked_texture: Texture2D
@export var unlocked_texture: Texture2D
@export var item_container_data: ItemContainerData

var chest_uid: String = ""

func _ready() -> void:
	chest_uid = _generate_id()
	
	if !LevelManager.current_level_data.containers.has(chest_uid):
		print("Not found in containers, adding now")
		LevelManager.current_level_data.containers.set(chest_uid, item_container_data)
		print("Containers data: " + str(LevelManager.current_level_data.containers))
		
	update_texture()

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
