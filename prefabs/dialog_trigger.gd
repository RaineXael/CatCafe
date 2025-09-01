extends Interactable

@export var dialog:Array[String]
var dialog_index:int = 0

@onready var dialog_object = $DialogBox


func interact(player:Player):
	dialog_object.read_text(dialog[dialog_index])
	
	dialog_index += 1
	if dialog_index >= dialog.size():
		dialog_index = 0
