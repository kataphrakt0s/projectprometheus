class_name HealthComponent extends Node

@export var max_hit_points: float
@export var debug_prints: bool
var current_hit_points: float


func _ready() -> void:
	pass

func get_current_hp() -> float:
	return current_hit_points

func take_damage(damage_value: float) -> void:
	current_hit_points = current_hit_points - damage_value
	get_parent().enemy_data.hp = current_hit_points
	
	if current_hit_points <= 0:
		get_parent().enemy_data.alive = false
		get_parent().queue_free()
	
	if debug_prints:
		print("%s took %d damage" % [get_parent().name, damage_value])

func gain_hp(heal_value: float) -> void:
	current_hit_points = current_hit_points + heal_value
