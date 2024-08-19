extends Node2D

@onready var atk_icon = $atk_icon
@onready var def_icon = $def_icon
@onready var rec_icon = $rec_icon
@onready var atp_icon = $atp_icon

var atp_adjustment = 0
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
	print(scalar)
	atp_adjustment = atp_modifier
	attack = int(atk * scalar)
	defense = int(def * scalar)
	recovery = int(heal * scalar)
	critical_chance = crit
	atk_icon.text = str(attack)
	def_icon.text = str(defense)
	rec_icon.text = str(recovery)
	atp_icon.text = str(300+atp_adjustment)+' ('+str(atp_adjustment)+')'
