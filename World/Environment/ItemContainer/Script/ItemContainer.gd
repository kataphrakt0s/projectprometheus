class_name ItemContainer
extends Node2D


@export var locked_texture: Texture2D
@export var unlocked_texture: Texture2D
@export var item_container_data: ItemContainerData
@export var selectable_name: String
@onready var item_container_sprite: Sprite2D = $Visual/ItemContainerSprite


var container_id: String = ""

func _ready() -> void:
	update_texture()
	
	container_id = _generate_id()
	
	if !LevelManager.current_level_data.containers.has(container_id):
		LevelManager.current_level_data.containers.set(container_id, item_container_data)
		

func _generate_id() -> String:
	var uid = "%s|%d|%d" % [
		get_parent().level_data.scene_path,
		int(global_position.x),
		int(global_position.y)
	]
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
