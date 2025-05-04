class_name LevelData extends Resource

@export var scene_path: String
var portals: Array[Portal]

# Container UID and associated data (opened, locked, contents)
var containers: Dictionary[String, ItemContainerData]

# Enemy UID and Enemy position and hp data
var enemies: Dictionary[String, EnemyData]
