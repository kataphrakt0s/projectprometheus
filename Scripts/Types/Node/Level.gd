extends Node2D

@export var level_name: String
@export var level_data: LevelData
@export var portals: Array[Portal]

func _ready() -> void:
	level_data.portals = portals
