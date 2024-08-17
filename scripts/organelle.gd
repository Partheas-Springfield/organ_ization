extends Node2D

@onready var org_sprite = $organelle_sprite
var type = null
var shape = [0,0,0,0]
var organelle_types = ['test1','test2','test3']
var organelle_dictionary = {
	[1,0,0,0] : ['test1'],
	[1,1,0,0] : ['test2'],
	[1,0,1,0] : ['test3']
	}

func get_shape(t):
	for key in organelle_dictionary:
		if t in organelle_dictionary[key]:
			return key

# Called when the node enters the scene tree for the first time.
func _ready():
	type = 'type' + str(randi_range(1,3))
	shape = get_shape(type)
	org_sprite.play(type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
