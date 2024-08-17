extends Node2D

@onready var selection = $selection
var incel = false
var id = 0
var hovered = false
signal tile_clicked
var iposition = Vector2i()


# Called when the node enters the scene tree for the first time.
func _ready():
	selection.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_iposition(ix,iy):
	iposition = Vector2i(ix,iy)

func get_iposition():
	return iposition

func set_incel(is_incel=true):
	incel = is_incel
	if is_incel:
		id = 1
	else:
		id = 0

func get_id():
	return id

func get_incel():
	return incel

func _on_mouse_entered():
	hovered = true
	selection.show()
	selection.play()

func _on_mouse_exited():
	hovered = false
	selection.hide()

func _unhandled_input(event):
	if hovered and Input.is_action_just_pressed('select'):
		emit_signal('tile_clicked')
