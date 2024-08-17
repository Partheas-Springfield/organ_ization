extends Node2D

@onready var organelle_sprite = $organelle
@onready var selection = $selection
var incel = false
var id = 0
var organelle = null
var hovered = false
signal tile_clicked
signal tile_entered
var iposition = Vector2i()


# Called when the node enters the scene tree for the first time.
func _ready():
	selection.hide()
	organelle_sprite.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_iposition(ix,iy):
	iposition = Vector2i(ix,iy)

func get_iposition():
	return iposition

func show_organelle():
	organelle_sprite.show()

func hide_organelle():
	organelle_sprite.hide()

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

func set_organelle(new_organelle):
	organelle = new_organelle
	organelle_sprite.play(organelle)

func get_organelle():
	return organelle

func _on_mouse_entered():
	hovered = true
	emit_signal('tile_entered')
	selection.show()
	selection.play()

func _on_mouse_exited():
	hovered = false
	selection.hide()

func _unhandled_input(event):
	if hovered and Input.is_action_just_pressed('select'):
		emit_signal('tile_clicked')
