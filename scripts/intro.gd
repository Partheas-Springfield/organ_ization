extends Node2D

var max_time = 12
var progress_bar
var fade_start = -12
var fade_rate = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = $ProgressBar
	progress_bar.max_value = max_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_bar.value+=delta
	fade_start += delta*fade_rate
	%Story.text = "[center][fade start=" + str(fade_start) + " length=5]CEO grants Vicky with her own microbiology lab due to her revolutionary new cell creator in the hopes that she can create a life extending superimmune cell. Assistant Inga, a grad student comes with the lab as free labor. Grad students in their barely waking state can only communicate in grunts though."


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
