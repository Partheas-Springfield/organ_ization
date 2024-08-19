extends Node2D

@onready var slots = $slots
var organelle_array = ['','','','','','','','','','','','']
# Called when the node enters the scene tree for the first time.
func _ready():
	for s in slots.get_children():
		s.pressed.connect(_slot_pressed.bind(s))
	add_to_next_slot('nucleus')
	var start_seed = randi_range(1,4)
	if start_seed == 1:
		add_to_next_slot('cellwall')
		add_to_next_slot('cellwall')
	elif start_seed == 2:
		add_to_next_slot('golgibody')
	elif start_seed == 3:
		add_to_next_slot('endoplasmicreticulum')
	elif start_seed == 4:
		add_to_next_slot('mitochondria')
		add_to_next_slot('ribosome')

func _get_next_slot():
	for s in slots.get_children():
		if s.get_button_icon() == null:
			return s
	return null

func get_slot_num(slot):
	return int(str(slot.get_path()).get_slice('slot',2))

func add_to_next_slot(organelle):
	if _get_next_slot() != null:
		var slot_num = get_slot_num(_get_next_slot())
		var icon = Image.load_from_file(Global.get_icon_path(organelle))
		_get_next_slot().set_button_icon(ImageTexture.create_from_image(icon))
		organelle_array[slot_num] = organelle
	

func _slot_pressed(slot):
	if slot.get_button_icon() == null:
		if Global.held_organelle != null:
			var icon = Image.load_from_file(Global.get_icon_path(Global.held_organelle))
			slot.set_button_icon(ImageTexture.create_from_image(icon))
			organelle_array[get_slot_num(slot)] = Global.held_organelle
			Global.held_organelle = null
	else:
		var to_return = organelle_array[get_slot_num(slot)]
		slot.set_button_icon(null)
		organelle_array[get_slot_num(slot)] = ''
		Global.held_organelle = to_return
