class_name NetworkManager
extends Node

var IP_ADDRESS: String = 'localhost'
var PORT:int = 5029
const MAX_CLIENTS = 32
var peer: ENetMultiplayerPeer

@onready var UI_Parent = $PanelContainer
@onready var textbox = $"../Chatbox"

@export var client_ip_input:LineEdit
@export var client_port_input:LineEdit
@export var server_port_input:LineEdit

@export var username:LineEdit
@export var color:ColorPickerButton

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
	textbox.username = username.text
func start_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	textbox.visible = true
	textbox.username = username.text
func _on_button_pressed() -> void:
	get_server_info()
	start_server()
	UI_Parent.visible = false

func _on_button_2_pressed() -> void:
	get_server_client_info()
	start_client()
	UI_Parent.visible = false
