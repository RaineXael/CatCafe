class_name Interactable
extends Area2D

func _ready():
	connect('body_entered', add_to_player_list)
	connect('body_exited', remove_from_player_list)
	
func add_to_player_list(body):
	if body is Player:
		body.add_to_interact_queue(self)

func remove_from_player_list(body):
	if body is Player:
		body.remove_from_interact_queue(self)


func interact(player:Player):
	printerr('Please override interact method!')
