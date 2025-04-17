extends Control

const EMPTY_SPRITE = preload("res://UI/HUD/Textures/EmptySprite.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actors.player.ui_texture_loaded.connect(update_selected)
	Actors.cursor.selection_changed.connect(update_selected)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_selected(node: Selectable) -> void:
	if node:
		%SelectedTextureRect.texture = node.ui_texture
		
	else:
		%SelectedTextureRect.texture = EMPTY_SPRITE
