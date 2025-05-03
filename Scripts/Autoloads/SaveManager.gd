extends Node

func save_game() -> void:
	var save_resource = Resource.new()
	save_resource.data = {
		"version": 1,
		"containers": _serialize_container_states(),
		"timestamp": Time.get_unix_time_from_system()
	}
	
	if ResourceSaver.save(save_resource, "user://savegame.tres") != OK:
		push_error("Failed to save game!")

func load_game() -> void:
	if ResourceLoader.exists("user://savegame.tres"):
		var save_resource = ResourceLoader.load("user://savegame.tres")
		if save_resource and save_resource.has("data"):
			_deserialize_container_states(save_resource.data.get("containers", {}))

func _serialize_container_states() -> Dictionary:
	var serialized = {}
	for level in LevelManager._container_states:
		serialized[level] = {}
		for container_id in LevelManager._container_states[level]:
			var state = LevelManager._container_states[level][container_id]
			serialized[level][container_id] = {
				"opened": state.get("opened", false),
				"contents": _serialize_items(state.get("contents", []))
			}
	return serialized

func _deserialize_container_states(serialized: Dictionary) -> void:
	LevelManager._container_states.clear()
	for level in serialized:
		LevelManager._container_states[level] = {}
		for container_id in serialized[level]:
			var data = serialized[level][container_id]
			LevelManager._container_states[level][container_id] = {
				"opened": data.get("opened", false),
				"contents": _deserialize_items(data.get("contents", []))
			}

# NEW: Item serialization functions
func _serialize_items(items: Array) -> Array:
	var serialized = []
	for item in items:
		if item is Resource and item.has_method("get_save_data"):
			serialized.append(item.get_save_data())
		elif item is Resource and item.resource_path:
			serialized.append({
				"type": "resource",
				"path": item.resource_path
			})
		else:
			serialized.append({
				"type": "inline",
				"data": {
					"name": item.name if "name" in item else "Unnamed",
					"texture": item.texture.resource_path if "texture" in item and item.texture else ""
				}
			})
	return serialized

func _deserialize_items(serialized_items: Array) -> Array:
	var items = []
	for item_data in serialized_items:
		if item_data["type"] == "resource" and ResourceLoader.exists(item_data["path"]):
			items.append(ResourceLoader.load(item_data["path"]))
		elif item_data["type"] == "inline":
			var item = Item.new()
			if "name" in item_data["data"]:
				item.name = item_data["data"]["name"]
			if "texture" in item_data["data"] and item_data["data"]["texture"]:
				item.texture = load(item_data["data"]["texture"])
			items.append(item)
	return items
