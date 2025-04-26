extends Control

const EMPTY_SPRITE = preload("res://UI/HUD/Textures/EmptySprite.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player.ui_texture_loaded.connect(update_selected)
	Global.cursor.selection_changed.connect(update_selected)
	LevelManager.transition_completed.connect(_on_level_loaded)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_selected(node: Selectable) -> void:
	if node:
		%SelectedTextureRect.texture = node.ui_texture
		%SelectedLabel.text = node.selection_name
	else:
		%SelectedTextureRect.texture = EMPTY_SPRITE
		%SelectedLabel.text = "None"

func _on_level_loaded():
	Global.update_level()
	Global.player.ui_texture_loaded.connect(update_selected)
	Global.cursor.selection_changed.connect(update_selected)
