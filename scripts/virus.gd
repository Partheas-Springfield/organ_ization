extends Node2D

@onready var virus_health_bar = $virus_health_bar
@onready var virus_sprite = $virus_sprite
@onready var virus_name = $virus_name
var color = null
var hp = randi_range(15,25)
var atk = randi_range(8,15)
var def = randi_range(0,5)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()
	virus_health_bar.set_max_hp(hp)
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

func difficulty_scale(scalar):
	hp = int(scalar * hp)
	atk = int(scalar * atk)
	def = int(scalar * def)

func randomize_color():
	const colors = ['red','green','purple']
	set_color(colors[randi_range(0,colors.size()-1)])
