extends Node2D

@export var id:int = 0 

var current_player

@onready var player_manager_instance:PlayerManager = $PlayerManager
func _ready() -> void:
	
	if not multiplayer.is_server():
		var player = player_manager_instance.multiplayer_spawner.spawn_player(multiplayer.get_unique_id())
		

func get_current_player():
	for player:Player in player_manager_instance.player_collection.get_children():
		if player.name.to_int() == multiplayer.get_unique_id():
			return player
		return
	
func reparent_player_to_player_manager(player:Player):
	player.reparent(player_manager_instance.player_collection)
