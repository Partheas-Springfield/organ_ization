extends Node2D

signal add_to_next
signal slot_pressed
@onready var slots = $slots

var organelle_array = ['','','','','','','','','','','','','']
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setup():
	for s in slots.get_children():
		s.pressed.connect(_slot_pressed.bind(s))
	add_to_next_slot('nucleus')
	add_to_next_slot('golgibody')

func get_next_slot():
	for s in slots.get_children():
		if s.get_button_icon() == null:
			return s
	return null

func get_slot_num(slot):
	return int(str(slot.get_path()).get_slice('slot',2))

func get_slot(num):
	for s in slots.get_children():
		if get_slot_num(s)== num:
			return s

func add_to_next_slot(organelle):
	Global.temp_organelle = organelle
	emit_signal('add_to_next')
	'''
	if _get_next_slot() != null:
		var slot_num = get_slot_num(_get_next_slot())
		_get_next_slot().set_button_icon(Global.load_image(organelle))
		organelle_array[slot_num] = organelle
	'''

func _slot_pressed(slot):
	Global.temp_slot = get_slot_num(slot)
	emit_signal('slot_pressed')
	'''
	if slot.get_button_icon() == null:
		if Global.held_organelle != null:
			slot.set_button_icon(Global.load_image(Global.held_organelle))
			organelle_array[get_slot_num(slot)] = Global.held_organelle
			Global.held_organelle = null
	elif Global.held_organelle == null:
		var to_return = organelle_array[get_slot_num(slot)]
		slot.set_button_icon(null)
		organelle_array[get_slot_num(slot)] = ''
		Global.held_organelle = to_return
	else:
		var temp = Global.held_organelle
		var to_return = organelle_array[get_slot_num(slot)]
		slot.set_button_icon(null)
		organelle_array[get_slot_num(slot)] = ''
		Global.held_organelle = to_return
		slot.set_button_icon(Global.load_image(temp))
		organelle_array[get_slot_num(slot)] = temp
'''

func all_slots_empty():
	for s in slots.get_children():
		if s.get_button_icon() != null:
			return false
	return true


func _on_title_button_pressed():
	if Global.held_organelle != null:
		if get_next_slot() != null:
			add_to_next_slot(Global.held_organelle)
			Global.held_organelle = null
