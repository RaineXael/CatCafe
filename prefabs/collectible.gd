extends Node2D

@export var worth:int = 1
@onready var sprite = $Path2D/PathFollow2D/Sprite2D
@onready var pathfollow:PathFollow2D = $Path2D/PathFollow2D
@onready var path:Path2D = $Path2D
var player:Player
var collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var total_time = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !collected:
		total_time += delta
		sprite.position.y = sin(total_time*8) * 8
	else:
		
		path.curve.set_point_in(1,Vector2(((player.global_position - global_position)/1.5).x,-120))
		path.curve.set_point_position(1, player.global_position - global_position)
		pathfollow.progress_ratio += delta *4
		
		if pathfollow.progress_ratio >= 1:
			player.get_money(worth)
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not collected:
		if body.get_multiplayer_authority() == multiplayer.get_unique_id():
			#body is player and belongs to the player, increase their count
			player = body
			collected = true
			path.curve = Curve2D.new()
			path.curve.add_point(Vector2.ZERO)
			path.curve.add_point(player.global_position - global_position)
			
