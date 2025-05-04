extends Control

const EMPTY_SPRITE = preload("res://UI/HUD/Textures/EmptySprite.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_selected(node: SelectableComponent) -> void:
	if node:
		%SelectedTextureRect.texture = node.ui_texture
		%SelectedLabel.text = node.selection_name
	else:
		%SelectedTextureRect.texture = EMPTY_SPRITE
		%SelectedLabel.text = "None"

func debug_update_player_hp(new_value: float) -> void:
	%PlayerHP.text = str(new_value)
