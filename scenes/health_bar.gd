extends Node2D

var max_hp
var current_hp
var yellow_hp
var red_hp
@onready var shell = $shell
@onready var bar = $bar

# Called when the node enters the scene tree for the first time.
func _ready():
	set_max_hp(100)
	set_current_hp(80)

func _update_display():
	bar.scale.x = float(current_hp)/float(max_hp)
	if current_hp > yellow_hp:
		bar.play('green')
	elif current_hp > red_hp:
		bar.play('yellow')
	else:
		bar.play('red')


func set_max_hp(hp_value):
	max_hp = hp_value
	current_hp = max_hp
	yellow_hp = int(max_hp * .67)
	red_hp = int(max_hp * .33)

func set_current_hp(hp_value):
	current_hp = hp_value
	_update_display()

func update_hp(hp_change):
	current_hp += hp_change
	_update_display()
