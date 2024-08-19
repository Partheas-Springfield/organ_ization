extends Node2D

@export var focus_send = Control.new()
var scene = 0
var fade_start = 0
var fade = fade_start
var fade_rate = 40
var story_index = 0
var speaker_list
var text_list

# Called when the node enters the scene tree for the first time.
func _ready():
	speaker_list = Global.intro_speaker
	text_list = Global.intro_text
	$Nameplate.text = "[center]" + speaker_list[story_index]
	$Portrait.play(speaker_list[story_index])
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fade += delta*fade_rate
	%Story.text = "[fade start=" + str(fade) + " length=1]" + text_list[story_index]

"""
func progress(value):
	if value == max_time:
		get_tree().change_scene_to_file('res://scenes/title.tscn')
	if value > (max_time*4)/5:
		%Text.text="[center][wave][rainbow]Living on a prayer![/rainbow][/wave][/center]"
	elif value > max_time/2:
		%Text.text="[center][shake]Halfway there..."
"""

func start():
	fade=fade_start
	show()

func skip_press():
	_advance()

func skip_down():
	%Skip.text = ":("

func _on_next_pressed():
	if fade<text_list[story_index].length(): fade=text_list[story_index].length()
	elif story_index<text_list.size()-1:
		story_index+=1
		fade = fade_start
		$Nameplate.text = "[center]" + speaker_list[story_index]
		$Portrait.play(speaker_list[story_index])
	else: _advance()
		

func _advance():
	scene+=1
	fade=0
	story_index=0
	match scene:
		#1:
			#speaker_list=
		_:pass
	hide()
	if Global.controller:focus_send.grab_focus()

func _input(event):
	if !is_visible_in_tree():pass
	if Global.controller:
		if event.as_text().contains("Mouse"):
			Global.controller = false
			get_viewport().gui_release_focus()
	else:
		if !event.as_text().contains("Mouse"):
			Global.controller = true
			$Next.grab_focus()
