extends Node2D

@onready var virus_health_bar = $virus_health_bar
@onready var virus_sprite = $virus_sprite
@onready var virus_name = $virus_name
@onready var atk_def = $atk_def
var color = null
var hp = randi_range(15,25)
var atk = randi_range(8,15)
var def = randi_range(0,3)
var id

signal virus_highlight
signal virus_unhighlight

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()
	virus_health_bar.set_max_hp(hp)
	atk_def.text = (str(atk)+'
'+str(def))
	virus_sprite.play()

func set_color(new_color):
	color = new_color
	virus_sprite.play(color)
	if color == 'red':
		atk += 5
		virus_name.text = 'Fierce Virus'
	elif color == 'purple':
		def += 5
		virus_name.text = 'Tough Virus'
	elif color == 'green':
		virus_name.text = 'Sneaky Virus'

func get_color():
	return color

func get_hp():
	return hp

func get_atk():
	return atk

func get_def():
	return def

func get_id():
	return id

func difficulty_scale(scalar):
	hp = int(scalar * hp)
	atk = int(scalar * atk)
	def = int(scalar * def)

func randomize_color():
	const colors = ['red','green','purple']
	set_color(colors[randi_range(0,colors.size()-1)])

func highlight(boo = true):
	if boo:
		virus_sprite.play(color + '_h')
	else:
		virus_sprite.play(color)


func _on_virus_name_focus_entered():
	emit_signal('virus_highlight')
	highlight()

func _on_virus_name_mouse_entered():
	emit_signal('virus_highlight')
	highlight()

func _on_virus_name_mouse_exited():
	emit_signal('virus_unhighlight')
	highlight(false)

func _on_virus_name_focus_exited():
	emit_signal('virus_unhighlight')
	highlight(false)
