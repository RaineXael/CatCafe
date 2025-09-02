class_name PlayerMultiplayerSpawner
extends MultiplayerSpawner


@export var net_player:PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	

func spawn_player_with_metadata(id:int, username:String, color:Color = Color.WHITE):
	#spawn_player(1)
	pass
func spawn_player(id:int):
	
	#only do it if called from the server
	if not multiplayer.is_server(): return
	
	var player: Player = net_player.instantiate()
	player.name = str(id)
	
	get_node(spawn_path).call_deferred('add_child', player)
	
