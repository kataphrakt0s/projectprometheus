extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_cancel_button_pressed() -> void:
	queue_free()


func _on_move_button_pressed() -> void:
	queue_free()
	# DEPRECATED
	#if GlobalRef.player.move_to(GlobalRef.cursor.global_position):
		#print("Moving")
	#else:
		#print("Failed to move")
