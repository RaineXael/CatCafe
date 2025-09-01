extends Interactable

@onready var master_scene 
@export_file var level_scene
func _ready() -> void:
	super._ready()
	master_scene = get_node('/root/MasterScene')


func interact(body:Player):
	
	body.change_room(master_scene.load_level(level_scene))
