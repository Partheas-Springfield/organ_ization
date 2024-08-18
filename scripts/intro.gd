extends Node2D

var max_time = 5
var progress_bar

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = $ProgressBar
	progress_bar.max_value = max_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_bar.value+=delta


func progress(value):
	if value == max_time:
		get_tree().change_scene_to_file('res://scenes/title.tscn')
	elif value > (max_time*4)/5:
		%Text.text="[center][wave][rainbow]Living on a prayer![/rainbow][/wave][/center]"
	elif value > max_time/2:
		%Text.text="[center][shake]Halfway there..."


func skip_press():
	get_tree().change_scene_to_file('res://scenes/title.tscn')


func skip_down():
	%Skip.text = ":("


func _input(event):
	if Global.controller:
		if event.as_text().contains("Mouse"):
			Global.controller = false
			get_viewport().gui_release_focus()
	else:
		if !event.as_text().contains("Mouse"):
			Global.controller = true
			%Skip.grab_focus()
