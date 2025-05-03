class_name ItemContainer
extends Node2D


@export var locked_texture: Texture2D
@export var unlocked_texture: Texture2D
@export var item_container_data: ItemContainerData
@export var selectable_name: String
@onready var item_container_sprite: Sprite2D = $Visual/ItemContainerSprite


var chest_uid: String = ""

func _ready() -> void:
	update_texture()
	
	chest_uid = _generate_id()
	
	if !LevelManager.current_level_data.containers.has(chest_uid):
		print("Not found in containers, adding now")
		LevelManager.current_level_data.containers.set(chest_uid, item_container_data)
		print("Containers data: " + str(LevelManager.current_level_data.containers))
		

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
		item_container_sprite.texture = locked_texture
		$Selectable.ui_texture = locked_texture
	else:
		item_container_sprite.texture = unlocked_texture
		$Selectable.ui_texture = unlocked_texture
