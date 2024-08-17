extends Node2D

@onready var org_sprite = $organelle_sprite
var type = null
var shape = null

func get_shape_from_type():
	for shape_key in Global.organelle_shape_dict:
		if type in Global.organelle_shape_dict[shape_key]:
			return shape_key
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_type():
	type = type
	shape = get_shape_from_type()
	org_sprite.play(type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
