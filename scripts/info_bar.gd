extends Node2D

@onready var atk_icon = $atk_icon
@onready var def_icon = $def_icon
@onready var rec_icon = $rec_icon
@onready var duo_icon = $duo_icon
@onready var atp_icon = $atp_icon

var atp_adjustment = 0
var current_atp = 0
var attack = 0
var defense = 0
var recovery = 0
var critical_chance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_display_stats(atp_modifier,atk,def,heal,crit,scalar):
	atp_adjustment = atp_modifier
	current_atp = 300 + atp_adjustment
	attack = int(atk * scalar)
	defense = int(def * scalar)
	recovery = int(heal * scalar)
	critical_chance = crit
	_update_display()

func _update_display():
	atk_icon.text = 'ATK: '+str(attack)
	def_icon.text = 'DEF: '+str(defense)
	rec_icon.text = 'HEAL: '+str(recovery)
	atp_icon.text = 'ATP: '+str(current_atp)+'/'+str(300+atp_adjustment)+' ('+str(atp_adjustment)+')'
	duo_icon.text = 'CRIT: '+str(critical_chance)+'%'

func get_atk():
	return attack

func get_def():
	return defense

func get_rec():
	return recovery

func get_duo():
	return float(critical_chance)/100.

func use_atp(amount):
	current_atp -= amount
	_update_display()

func duo_activation():
	if randf() <= get_duo():
		print('CRIT')
		return 2
	return 1

func restore_atp():
	current_atp = get_max_atp()

func get_max_atp():
	return 300+atp_adjustment

func get_curr_atp():
	return current_atp
