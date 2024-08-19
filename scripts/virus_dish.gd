extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$viruses/virus1.id = 0
	$viruses/virus2.id = 1
	$viruses/virus3.id = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
