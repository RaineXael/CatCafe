class_name Player
extends CharacterBody2D	


const SPEED = 170.0
const JUMP_VELOCITY = -400.0

@onready var camera:Camera2D = $Camera2D
@export var animator:AnimatedSprite2D

var username = 'Eiko'

var superjumping = false
var last_direction = 1
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:
		if multiplayer.get_unique_id() == name.to_int():
			$Camera2D.make_current()
			$AudioListener2D.make_current()
			
			var netman = get_node('/root/MasterScene/NetworkManager')
			animator.self_modulate = netman.color.color
			username = netman.username.text
			print(username)
			print(animator.self_modulate)
			$Camera2D/Label.text = username
		else:
			$Camera2D.enabled = false
			$AudioListener2D.clear_current()
func _physics_process(delta: float) -> void:
		
		
		if global_position.y > 9999:
			global_position = Vector2.ZERO

		if !is_multiplayer_authority(): 
			camera.enabled = false
			
			return
		
		
		if not is_on_floor():
			velocity += get_gravity() * delta * 1.5
		elif superjumping:
			superjumping = false
		
		
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			if Input.is_action_pressed("down"):
				velocity.y = JUMP_VELOCITY/2
				velocity.x = SPEED * 2.5 * last_direction
				superjumping = true
			else:
				velocity.y = JUMP_VELOCITY


		var direction := Input.get_axis("left", "right")
		
		if direction:
			last_direction = direction/abs(direction)
		
		if not superjumping:
			
			
			if direction and not Input.is_action_pressed("down"):
				velocity.x = direction * SPEED
				animator.flip_h = direction < 0
			else:
				
				velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if is_on_floor():
			if Input.is_action_pressed("down"):
				animator.play('crouch')
			else:
				if direction:
					animator.play('walk')
				else:
					animator.play('idle')
		else:
			animator.play('jump')
		
		move_and_slide()
