class_name NetworkManager
extends Node

var IP_ADDRESS: String = 'localhost'
var PORT:int = 5029
const MAX_CLIENTS = 32
var peer: ENetMultiplayerPeer

@onready var UI_Parent = $MainMenu

@export var client_ip_input:LineEdit
@export var client_port_input:LineEdit
@export var server_port_input:LineEdit

@export var username:LineEdit
@export var color:ColorPickerButton


@onready var master_scene = $".."

func _ready() -> void:
	load_data()

func get_server_info():
	if OS.has_feature("dedicated_server"): return
	PORT = server_port_input.text.to_int()
	
func get_server_client_info():
	if OS.has_feature("dedicated_server"): return
	IP_ADDRESS = client_ip_input.text
	PORT = client_port_input.text.to_int()
	
func start_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	#textbox.username = username.text
	master_scene.load_level(0)
	if OS.has_feature("dedicated_server"): 
		master_scene.load_level(1) 
		return
	

	#player_spawner.spawn_player(1)
	
	save_data()
func start_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	master_scene.load_level(0)
	save_data()
func _on_button_pressed() -> void:
	get_server_info()
	start_server()
	UI_Parent.visible = false

func _on_button_2_pressed() -> void:
	get_server_client_info()
	start_client()
	UI_Parent.visible = false
	
func save_data():
	var config = ConfigFile.new()
	config.set_value("Player", "username", username.text)
	config.set_value("Player", "color", color.color)
	config.save("user://data.cfg")
func load_data():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://data.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		return

	# Iterate over all sections.
	for player in config.get_sections():
		# Fetch the data for each section.

		var player_name = config.get_value(player, "username")
		var player_color = config.get_value(player, "color")
		
		username.text = player_name
		color.color = player_color
