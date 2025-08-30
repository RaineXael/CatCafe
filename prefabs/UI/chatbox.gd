extends CanvasLayer

@onready var message_container = $Chatbox/PanelContainer/VBoxContainer/ScrollContainer/ChatContainer
@onready var username_textfield = $Chatbox/PanelContainer/VBoxContainer/HBoxContainer2/LineEdit2
@onready var text_textfield = $Chatbox/PanelContainer/VBoxContainer/HBoxContainer/LineEdit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('toggle_chat'):
		$Label.visible = not $Label.visible
		$Chatbox.visible = not $Chatbox.visible

func _on_send_pressed() -> void:
	print('button rporwjikqawesrfjokawefsrjoikk')
	rpc("msg_rpc", username_textfield.text, text_textfield.text)

@rpc ('any_peer', 'call_local')
func msg_rpc(username, data):
	var a = Label.new()
	a.text = username + ': ' + data
	a.autowrap_mode = TextServer.AUTOWRAP_WORD
	a.custom_minimum_size.x = 192.0
	message_container.add_child(a)
