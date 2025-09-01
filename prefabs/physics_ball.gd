extends RigidBody2D

var origin_point:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin_point = global_position
	
	#Check if the autority(server) == the current ID (aka if it's the server)
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		freeze = true
		


  
		

func _physics_process(delta: float) -> void:
	
	pass
	
func _on_body_entered(body: Node) -> void:
	print(body)
