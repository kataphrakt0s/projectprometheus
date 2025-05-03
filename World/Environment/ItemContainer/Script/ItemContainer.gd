class_name ItemContainer extends Selectable

signal ui_texture_loaded(node: Selectable)


@export var locked_texture: AtlasTexture
@export var unlocked_texture: AtlasTexture
@export var locked: bool

@export_group("Contents")
@export var contents: Array[Item] # Currently stored items

@onready var item_container_sprite: Sprite2D = $ItemContainerSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_texture()
	ui_texture = await capture_canvas_item(item_container_sprite)
	ui_texture_loaded.emit(self)

func open() -> void:
	for item in contents:
		Global.player.add_item_to_inventory(item)

func unlock() -> void:
	locked = false
	update_texture()
	
func lock() -> void:
	locked = true
	update_texture()

func update_texture() -> void:
	if locked:
		item_container_sprite.texture = locked_texture
	else:
		item_container_sprite.texture = unlocked_texture
