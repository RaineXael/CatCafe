extends Interactable

@onready var master_scene 
@export var level_scene:int
func _ready() -> void:
	super._ready()
	master_scene = get_node('/root/MasterScene')


func interact(body:Player):
	
	master_scene.load_level(level_scene)
