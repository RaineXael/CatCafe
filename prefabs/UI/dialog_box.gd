extends Control
@export var autohide := true
@onready var label = $PanelContainer/Label
@onready var read_timer = $Timer
var read_done := false

@onready var origin_pos = position

func _ready() -> void:
	visible = false
	pass
func read_text(text:String):
	label.text = text
	label.visible_characters = 0
	read_timer.start()
	read_done = false
	visible = true
	position = origin_pos
	$Hidetextbox.stop()
func _process(delta: float) -> void:
	if label.visible_ratio >= 1:
		read_timer.stop()
		if !read_done:
			read_done = true
			$Hidetextbox.start()
	#position.y -= delta *2
		


func _on_timer_timeout() -> void:
	label.visible_characters += 1



func _on_hidetextbox_timeout() -> void:
	if autohide:
		visible = false
