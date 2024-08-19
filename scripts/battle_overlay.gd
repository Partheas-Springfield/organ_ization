extends Node2D

@onready var viruses = $virus_dish/viruses

signal attack
signal defend
signal heal
signal end_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_virus(num):
	return viruses.get_child(num)

func get_all_viruses():
	return viruses.get_children()


func _on_attack_pressed():
	emit_signal('attack')

func _on_defend_pressed():
	emit_signal('defend')

func _on_heal_pressed():
	emit_signal('heal')

func _on_end_turn_pressed():
	emit_signal('end_turn')
