class_name Portal extends Node2D

@export var locked_texture: AtlasTexture
@export var unlocked_texture: AtlasTexture
@export var locked: bool
@export var selectable_name: String
@export var to_level: String
@export var from_level: String

@onready var portal_sprite: Sprite2D = $Visual/PortalSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_texture()

func activate() -> void:
	LevelManager.change_level(to_level)
	
func unlock() -> void:
	locked = false
	update_texture()
	
func lock() -> void:
	locked = true
	update_texture()

func update_texture() -> void:
	if locked:
		portal_sprite.texture = locked_texture
		$Selectable.ui_texture = locked_texture

	else:
		portal_sprite.texture = unlocked_texture
		$Selectable.ui_texture = unlocked_texture
