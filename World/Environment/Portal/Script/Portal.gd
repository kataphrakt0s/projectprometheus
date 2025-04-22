extends Selectable

signal ui_texture_loaded(node: Selectable)

@export var locked_texture: AtlasTexture
@export var unlocked_texture: AtlasTexture
@export var locked: bool
@export var to_scene: PackedScene
@export var from_scene: PackedScene

@onready var portal_sprite: Sprite2D = $PortalSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_texture()
	ui_texture = await capture_canvas_item(portal_sprite)
	ui_texture_loaded.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate() -> void:
	pass
	
func unlock() -> void:
	locked = false
	portal_sprite.texture = unlocked_texture
	
func lock() -> void:
	locked = true
	portal_sprite.texture = locked_texture

func update_texture() -> void:
	if locked:
		portal_sprite.texture = locked_texture
	else:
		portal_sprite.texture = unlocked_texture
