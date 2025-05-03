extends Node

signal advance_tick_requested

func _ready() -> void:
	$"../Game/Cursor".selection_changed.connect(_new_selection)

func _new_selection(node: Selectable):
	Global.current_selection = node
