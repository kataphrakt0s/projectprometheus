extends Node2D

@export var level_data: LevelData
@export var portals: Array[Portal]
@export var containers: Array[ItemContainer]

func _ready() -> void:
	level_data.portals = portals
	level_data.containers = containers
