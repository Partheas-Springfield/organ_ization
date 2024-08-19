extends Node2D

@onready var organelle_sprite = $organelle
@onready var selection = $selection
@onready var hp_bar = $health_bar
@onready var target = $target_button/target
@onready var target_button = $target_button
@onready var def_icon = $def_icon
@onready var def_text = $def_icon/def_text

var incel = false
var id = 0
var organelle = null
var organelle_origin = null
var organelle_defense = 0
var hovered = false
var iposition = Vector2i()
var origin = false
var organelle_max_hp = 0
var organelle_hp = 0
var target_color = null
var target_number = 0

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
	if organelle_defense == 0:
		def_icon.hide()
	else:
		def_icon.show()
	if organelle_hp == organelle_max_hp:
		hp_bar.hide()
	else:
		hp_bar.show()

func reset_def_hp():
	organelle_defense = 0
	organelle_hp = organelle_max_hp

func set_iposition(ix,iy):
	iposition = Vector2i(ix,iy)

func get_iposition():
	return iposition

func show_organelle():
	organelle_sprite.show()
	set_organelle_stats(organelle)
	hp_bar.set_max_hp(organelle_max_hp)
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

func reset_def():
	organelle_defense = 0

func organelle_hp_change(amount):
	print(amount)
	if amount <= 0:
		if -amount >= organelle_defense:
			amount += organelle_defense
		else: amount = 0
	organelle_hp += amount
	hp_bar.show()
	hp_bar.update_hp(amount)
	if organelle_hp > organelle_max_hp:
		organelle_hp = organelle_max_hp
		hp_bar.hide()
	elif organelle_hp <= 0:
		emit_signal('organelle_death')

func get_id():
	return id

func add_defense(amount):
	organelle_defense += amount
	def_text.text = str(organelle_defense)

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


## Returns iposition of the organelle's top left origin
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

func set_target(color=null,number=0):
	target_number = number
	target_color = color
	if color == null:
		target_button.hide()
	else:
		target.play(color)
		target_button.show()

func get_target_number():
	return target_number

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

func highlight(boo=true):
	if boo: target.play(target_color+'_h')
	else: target.play(target_color)
		

func _on_target_button_mouse_entered():
	emit_signal('target_highlight')
	highlight()


func _on_target_button_mouse_exited():
	emit_signal('target_unhighlight')
	highlight(false)
