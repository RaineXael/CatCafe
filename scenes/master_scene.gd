extends Node2D

@onready var net_manager:NetworkManager = $NetworkManager


func _ready():
	if OS.has_feature("dedicated_server"):
		print('Starting Dedicated Server...')
		net_manager.start_server()
	
