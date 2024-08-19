extends Node2D

@onready var organelle_sprite = $organelle
@onready var selection = $selection
@onready var hp_bar = $health_bar
@onready var target = $target_button/target
@onready var target_button = $target_button

var incel = false
var id = 0
var organelle = null
var organelle_origin = null
var hovered = false
var iposition = Vector2i()
var origin = false
var organelle_max_hp = 0
var organelle_hp = 0
var target_color = null

signal tile_clicked
signal tile_entered
signal organelle_death
signal target_highlight
signal target_unhighlight

# Called when the node enters the scene tree for the first time.
func _ready():
	hp_bar.hide()
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
	set_organelle_stats(organelle)
	origin = true

func hide_organelle():
	organelle_sprite.hide()
	hp_bar.hide()
	set_organelle_stats(null)
	origin = false

func set_incel(is_incel=true):
	incel = is_incel
	if is_incel:
		id = 1
	else:
		id = 0

func organelle_hp_change(amount):
	organelle_hp += amount
	hp_bar.show()
	if organelle_hp > organelle_max_hp:
		organelle_hp = organelle_max_hp
		hp_bar.hide()
	elif organelle_hp <= 0:
		emit_signal('organelle_death')

func get_id():
	return id

func is_origin():
	return origin

func get_incel():
	return incel

func set_organelle(new_organelle=null,origin=null):
	organelle = new_organelle
	organelle_origin = origin
	organelle_sprite.play(str(organelle))
	if new_organelle == null:
		organelle_max_hp = 0
		organelle_hp = 0

func get_organelle():
	return organelle

func get_organelle_origin():
	return organelle_origin

func _on_mouse_entered():
	hovered = true
	emit_signal('tile_entered')
	selection.show()
	selection.play()

func selected():
	hovered = true
	emit_signal('tile_entered')
	selection.show()
	selection.play()

func _on_mouse_exited():
	hovered = false
	selection.hide()

func set_target(color=null):
	if color == null:
		target.hide()
	else:
		print(color)
		target_color = color
		target_button.show()

func deselected():
	hovered = false
	selection.hide()

func _unhandled_input(event):
	if hovered and Input.is_action_just_pressed('select'):
		emit_signal('tile_clicked')

func set_organelle_stats(new_organelle):
	if organelle == null:
		organelle_hp = 0
		organelle_max_hp = 0
	else:
		organelle_hp = Global.get_organelle_hp(new_organelle)
		organelle_max_hp = Global.get_organelle_hp(new_organelle)


func _on_target_button_mouse_entered():
	emit_signal('target_highlight')
	target.play(target_color+'_h')


func _on_target_button_mouse_exited():
	emit_signal('target_unhighlight')
	target.play(target_color)
