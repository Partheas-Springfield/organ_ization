extends Node2D

@onready var viruses = $virus_dish/viruses

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_virus(num):
	return viruses.get_child(num-1)
