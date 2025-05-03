class_name Portal extends Selectable

signal ui_texture_loaded(node: Selectable)

@export var locked_texture: AtlasTexture
@export var unlocked_texture: AtlasTexture
@export var locked: bool
@export var to_level: String
@export var from_level: String

@onready var portal_sprite: Sprite2D = $PortalSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_texture()
	ui_texture = await capture_canvas_item(portal_sprite)
	ui_texture_loaded.emit(self)

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
	else:
		portal_sprite.texture = unlocked_texture
