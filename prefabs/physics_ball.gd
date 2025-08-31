extends RigidBody2D

var origin_point:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin_point = global_position



func _physics_process(delta: float) -> void:
	
	pass
	
func _on_body_entered(body: Node) -> void:
	print(body)
