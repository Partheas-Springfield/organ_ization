extends Node2D

@export var scene = "build"
var fade_start = 0
var fade = fade_start
var fade_rate = 40
var story_index = 0
var delay = fade_rate*3
var speaker_list
var text_list

# Called when the node enters the scene tree for the first time.
func _ready():
	match scene:
		"build":
			speaker_list = Global.build_speaker
			text_list = Global.build_text
		"battle":
			speaker_list = Global.battle_speaker
			text_list = Global.battle_text
	$Nameplate.text = "[center]" + speaker_list[story_index]
	$Portrait.play(speaker_list[story_index])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_visible_in_tree():
		fade += delta*fade_rate
		if fade<=text_list[story_index].length():
			%Story.text = "[center][fade start=" + str(fade) + " length=1]" + text_list[story_index]
		if story_index==speaker_list.size()-1||story_index==text_list.size()-1:
			pass
		elif fade>text_list[story_index].length()+delay:
			story_index+=1
			fade = fade_start
			$Nameplate.text = "[center]" + speaker_list[story_index]
			$Portrait.play(speaker_list[story_index])
