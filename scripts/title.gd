extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_start():
	pass

func on_settings():
	$TitleBox.hide()
	$Settings.show()

func on_instructions():
	$TitleBox.hide()
	$Instructions.show()

func on_credits():
	$TitleBox.hide()
	$Credits.show()

func on_settings_back():
	$TitleBox.show()
	$Settings.hide()

func on_instructions_back():
	$TitleBox.show()
	$Instructions.hide()

func on_credits_back():
	$TitleBox.show()
	$Credits.hide()
