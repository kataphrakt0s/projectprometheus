class_name HealthComponent extends Node

@export var max_hit_points: float
@export var debug_prints: bool
var current_hit_points: float


func _ready() -> void:
	current_hit_points = max_hit_points

func get_current_hp() -> float:
	return current_hit_points

func take_damage(damage_value: float) -> void:
	current_hit_points = current_hit_points - damage_value
	if debug_prints:
		print("%s took %d damage" % [get_parent().name, damage_value])

func gain_hp(heal_value: float) -> void:
	current_hit_points = current_hit_points + heal_value
