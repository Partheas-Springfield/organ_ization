extends Node2D

@export var exit_button = Button
var reward = null
var organelles=['','','']
var size = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_rewards()
	assign_neighbors(exit_button)

func randomize_rewards():
	for num in range(3):
		organelles[num]=(Global.random_organelle())
	size = Global.organelle_size_dict[organelles[0]]
	%Choice1.set_size(64*size)
	%Choice1.set_position(Vector2(32+(3-size.x)*32,(3-size.y)*32))
	%Choice1/organelle.play(organelles[0])
	size = Global.organelle_size_dict[organelles[1]]
	%Choice2.set_size(64*size)
	%Choice2.set_position(Vector2(224+(3-size.x)*32,(3-size.y)*32))
	%Choice2/organelle.play(organelles[1])
	size = Global.organelle_size_dict[organelles[2]]
	%Choice3.set_size(64*size)
	%Choice3.set_position(Vector2(416+(3-size.x)*32,(3-size.y)*32))
	%Choice3/organelle.play(organelles[2])

func assign_neighbors(button):
	button.set_focus_neighbor(SIDE_LEFT, %Choice1.get_path())
	button.set_focus_neighbor(SIDE_TOP, %Choice2.get_path())
	button.set_focus_neighbor(SIDE_RIGHT, %Choice3.get_path())
	%Choice1.set_focus_neighbor(SIDE_TOP, button.get_path())
	%Choice2.set_focus_neighbor(SIDE_TOP, button.get_path())
	%Choice3.set_focus_neighbor(SIDE_TOP, button.get_path())

#region Button Logic
func _on_choice_1_pressed():
	reward = organelles[0]
	exit_button.text = "Select " + organelles[0]

func _on_choice_2_pressed():
	reward = organelles[1]
	exit_button.text = "Select " + organelles[1]

func _on_choice_3_pressed():
	reward = organelles[2]
	exit_button.text = "Select " + organelles[2]
#endregion
