extends Node2D

@onready var net_manager:NetworkManager = $NetworkManager
var current_level
@onready var level_spawner:MultiplayerSpawner = $LevelSpawner
func _ready():
	if OS.has_feature("dedicated_server"):
		print('Starting Dedicated Server...')
		net_manager.start_server()
	
func load_level(path:String):
	var loaded_level = load(path)
	if current_level:
		current_level.queue_free()
	var level_inst = loaded_level.instantiate()
	add_child(level_inst)
	level_spawner.spawn(level_inst)
	current_level = level_inst
	return current_level.id
