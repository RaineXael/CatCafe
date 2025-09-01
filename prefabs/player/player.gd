class_name Player
extends CharacterBody2D	

const SPEED = 170.0
const JUMP_VELOCITY = -400.0

var money:int = 0

@onready var camera:Camera2D = $Camera2D
@export var animator:AnimatedSprite2D
@onready var meow_sfx:AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var multiplayer_sync:MultiplayerSynchronizer
@export var can_pounce := false

var interact_list:Array[Interactable]

@export var current_room:int = 0


var username = 'Eiko'
var direction
var superjumping = false
var last_direction = 1

@onready var player_collection = get_node('/root/MasterScene/PlayerCollection')


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:
		if multiplayer.get_unique_id() == name.to_int():
			$Camera2D.make_current()
			$AudioListener2D.make_current()
			$PlayerUI.visible = true
			var netman = get_node('/root/MasterScene/NetworkManager')
			animator.self_modulate = netman.color.color
			username = netman.username.text
			print(username)
			print(animator.self_modulate)
			$Camera2D/Label.text = username
			print('the current player')
		else:
			print('not the current player')
			$Camera2D.enabled = false
			$PlayerUI.visible = false
			$AudioListener2D.clear_current()
		change_room(0)
func _physics_process(delta: float) -> void:
		
		
		if global_position.y > 9999:
			global_position = Vector2.ZERO

		if !is_multiplayer_authority(): 
			camera.enabled = false
			
			return
		
		
		if Input.is_action_just_pressed("zoom_in"):
			camera.zoom += Vector2(0.1,0.1)
		
		if Input.is_action_just_pressed("zoom_out"):
			camera.zoom -= Vector2(0.1,0.1)
		if Input.is_action_just_pressed("zoom_reset"):
			camera.zoom = Vector2.ONE
		if not is_on_floor():
			velocity += get_gravity() * delta * 1.5
		elif superjumping:
			superjumping = false
		
		if Input.is_action_just_pressed("interact"):
			if interact_list.size() > 0:
				interact_list[0].interact(self)
			else:
				rpc("meow")
		
		if Input.is_action_just_pressed("down"):
			meowing = false
		
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			if Input.is_action_pressed("down") and can_pounce:
				velocity.y = JUMP_VELOCITY/2
				velocity.x = SPEED * 2.5 * last_direction
				superjumping = true
				$jumpsound.play()
			else:
				velocity.y = JUMP_VELOCITY
				$jumpsound.play()
				

		direction = Input.get_axis("left", "right")
		
		if direction:
			meowing = false
			last_direction = direction/abs(direction)
		
		if not superjumping:
			
			
			if direction and not Input.is_action_pressed("down"):
				velocity.x = direction * SPEED
				animator.flip_h = direction < 0
				
			else:
				
				velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if is_on_floor():
				if Input.is_action_pressed("down"):
					if meowing:
						animator.play('meow_crouch')
					else:
						animator.play('crouch')
					
				else:
					if meowing:
						animator.play('meow')
					else:
						
						if direction:
							animator.play('walk')
						else:
							animator.play('idle')
		else:
			animator.play('jump')
		
		move_and_slide()

var meowing:bool = false

@rpc("any_peer", "call_local")
func meow():
	meow_sfx.play()
	if is_on_floor() and direction == 0:
		meowing = true

@rpc("any_peer", "call_local")
func show_textbox(text:String):
	$DialogBox.read_text(text)

func get_money(amount:int):
	money += amount
	$moneysound.play()
	print('mnuy')
	$PlayerUI/Control/HBoxContainer/Moneycount.text = ': ' + str(money)


func _on_chatbox_on_text_chat(text: String) -> void:
	rpc('show_textbox', text)


func add_to_interact_queue(body):
	if multiplayer.get_unique_id() == name.to_int():
		interact_list.append(body)
		
func remove_from_interact_queue(body):
	if multiplayer.get_unique_id() == name.to_int():
		interact_list.erase(body)

func change_room(id:int):
	
	#gameplan: Iterate over the whole playerobjectlist (locally)
	#For those who share room id#, set their replicator visibility to on
	##else off
	#
	##should be easy right :) :) :)
	#current_room = id
	#for player:Player in player_collection.get_children():
		##sets the sync visibility for this peer to the ones inside the current room
		#print('in room ' + str(id))
		#player.multiplayer_sync.set_visibility_for(name.to_int(),player.current_room == current_room)
		#pass
		#
	#
	
	
	pass
	
