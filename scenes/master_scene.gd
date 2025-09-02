extends Node2D

@onready var net_manager:NetworkManager = $NetworkManager
var current_level

var current_player:Player
var server_levels := {}
var level_list = [
	"res://scenes/level_1.tscn",
	"res://scenes/level_2.tscn"
]


func _ready():
	if OS.has_feature("dedicated_server"):
		print('Starting Dedicated Server...')
		net_manager.start_server()
	
func load_level(id:int):
	
	if multiplayer.is_server():
		load_level_server(id)
	else:
		_load_level_client(id)
	
	
	
func _load_level_client(id:int):
	var loaded_level = load(level_list[id])
	
	var level_inst = loaded_level.instantiate()
	add_child(level_inst)
	print(current_player)
	#if current_player:
	#	level_inst.reparent_player_to_player_manager(current_player)
	if current_level:
		current_level.queue_free()
	current_level = level_inst
	print('client loading scene' + str(id))
	return current_level.id
	
	
	
func load_level_server(id:int):
	#Server level loading: Have a collection of levels {room_id = 1, <packedscene>}
	#Whenever a client load a level, make them load it on their side but also send
	#an rpc call to make the server load it, if it doesn't already exist in the
	#list. 	
	var loaded_level = load(level_list[id])
	
	var level_inst = loaded_level.instantiate()
	add_child(level_inst)
	if current_player:
		level_inst.reparent_player_to_player_manager(current_player)
	
	print('server loading scene' + str(id))
	pass
