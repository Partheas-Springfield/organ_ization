extends Node2D

var progress_bar
var fade_start = -12
var fade = fade_start
@export var fade_rate = 40
var story_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Nameplate.text = Global.intro_speaker[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fade += delta*fade_rate
	%Story.text = "[fade start=" + str(fade) + " length=1]" + Global.intro_text[story_index]

"""
func progress(value):
	if value == max_time:
		get_tree().change_scene_to_file('res://scenes/title.tscn')
	if value > (max_time*4)/5:
		%Text.text="[center][wave][rainbow]Living on a prayer![/rainbow][/wave][/center]"
	elif value > max_time/2:
		%Text.text="[center][shake]Halfway there..."
"""

func skip_press():
	get_tree().change_scene_to_file('res://scenes/title.tscn')


func skip_down():
	%Skip.text = ":("

func _on_next_pressed():
	if story_index<Global.intro_text.size()-1:
		story_index+=1
		fade = fade_start
		$Nameplate.text = Global.intro_speaker[story_index]
	else: get_tree().change_scene_to_file('res://scenes/title.tscn')
		


func _input(event):
	if Global.controller:
		if event.as_text().contains("Mouse"):
			Global.controller = false
			get_viewport().gui_release_focus()
	else:
		if !event.as_text().contains("Mouse"):
			Global.controller = true
			$Next.grab_focus()
