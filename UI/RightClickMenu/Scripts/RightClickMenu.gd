extends Control

const ItemContainerInventory: PackedScene = preload("res://UI/HUD/ItemContainerInventory/Scene/ItemContainerInventory.tscn")

func _on_move_button_pressed() -> void:
	queue_free()
	# DEPRECATED
	#if GlobalRef.player.move_to(GlobalRef.cursor.global_position):
		#print("Moving")
	#else:
		#print("Failed to move")


func _on_open_button_pressed() -> void:
	if Global.current_selection.locked:
		Global.current_selection.unlock()
	else:
		#TODO
		# Change this to open a window with the contents of the container
		if Global.current_selection.contents.size() == 0:
			print("No items in container!")
		else:
			Global.HUD.add_child(ItemContainerInventory.instantiate())
	queue_free()


func _on_attack_button_pressed() -> void:
	pass # Replace with function body.


func _on_cancel_button_pressed() -> void:
	queue_free()

func configure_buttons() -> void:
	if Global.current_selection:
		if Global.current_selection is ItemContainer && Global.current_selection != null:
			
			$PanelContainer/VBoxContainer/OpenButton.show()
		else:
			$PanelContainer/VBoxContainer/OpenButton.hide()
	else:
		$PanelContainer/VBoxContainer/OpenButton.hide()
