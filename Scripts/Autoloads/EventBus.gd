extends Node

signal advance_tick_requested

func _ready() -> void:
	$"../Game/Cursor".selection_changed.connect(_new_selection)

func _new_selection(node: Node2D):
	if node && node.get_node("Selectable"):
		Global.current_selection = node
		$"../Game/HUD/HUD".update_selected(node.get_node("Selectable"))
	else:
		Global.current_selection = node
		$"../Game/HUD/HUD".update_selected(node)
