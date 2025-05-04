extends Control

const ItemContainerInventory: PackedScene = preload("res://UI/HUD/ItemContainerInventory/Scene/ItemContainerInventory.tscn")

func _on_move_button_pressed() -> void:
	hide()
	# DEPRECATED
	#if GlobalRef.player.move_to(GlobalRef.cursor.global_position):
		#print("Moving")
	#else:
		#print("Failed to move")


func _on_open_button_pressed() -> void:
	if Global.current_selection.item_container_data.locked:
		Global.current_selection.unlock()
	else:
		if Global.current_selection.item_container_data.contents.size() == 0:
			print("No items in container!")
		else:
			$"../../HUD".add_child(ItemContainerInventory.instantiate())
	hide()


func _on_attack_button_pressed() -> void:
	for player in get_tree().get_nodes_in_group("Player"):
		var attack_roll = randf()
		player.attack(Global.current_selection, player.damage_value, attack_roll)
	hide()


func _on_cancel_button_pressed() -> void:
	hide()

func configure_buttons() -> void:
	if Global.current_selection:
		# Show Open button if selection is a container
		if Global.current_selection is ItemContainer && Global.current_selection != null:
			$PanelContainer/VBoxContainer/OpenButton.show()
		else:
			$PanelContainer/VBoxContainer/OpenButton.hide()
		
		# Show Attack button if selection is an Enemy
		if Global.current_selection.is_in_group("Enemy"):
			$PanelContainer/VBoxContainer/AttackButton.show()
		else:
			$PanelContainer/VBoxContainer/AttackButton.hide()
	else:
		return
