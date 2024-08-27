extends Node2D

@export var music = AudioStreamPlayer.new() ## Music player to use
var fade_start = 0
var delay = 20
var length = 20
var rate = 10
var credits
var music_duration=0.0
@onready var music_length=$Victory.get_stream().get_length()

# Called when the node enters the scene tree for the first time.
func _ready():
	credits = $Credits.get_children()
	#hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	music_duration+=delta
	fade_start+=delta*rate
	var index = 0
	for line in credits:
		line.text="[center][fade fade start=" + str(fade_start-(delay*(index+1))) + " length=" + str(length) + "]" + Global.credits[index]
		index+=1

func switch(state = "win"):
	#music.stop()
	if state=="win":
		$Header.text = "[center]Victory!"
		$Victory.volume_db = linear_to_db(Global.music_volume*Global.volume_scale)
		$Victory.play()
		music_duration=0.0
	else:
		$Header.text = "[center]Game Over"
		#music.stop()
	fade_start = 0
	show()


func _on_title_pressed():
	Global.level=0
	if $Victory.playing:
		Global.track_save="C4Y"
		Global.music_save=fmod(music_duration,music_length)
	elif music.playing:
		Global.track_save="title"
		Global.music_save=fmod(music_duration,music_length)
	get_tree().change_scene_to_file('res://scenes/title.tscn')
