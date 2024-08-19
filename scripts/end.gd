extends Node2D

@export var music = AudioStreamPlayer.new() ## Music player to use
var fade_start = 0
var delay = 20
var length = 20
var rate = 10
var credits

# Called when the node enters the scene tree for the first time.
func _ready():
	credits = $Credits.get_children()
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fade_start+=delta*rate
	var index = 0
	for line in credits:
		line.text="[center][fade fade start=" + str(fade_start-(delay*(index+1))) + " length=" + str(length) + "]" + Global.credits[index]
		index+=1

func switch(state = "win"):
	if state=="win":
		$Header.text = "[center]Victory!"
		music.play()
	else:
		$Header.text = "[center]Game Over"
		music.stop()
	fade_start = 0
	show()


func _on_title_pressed():
	get_tree().change_scene_to_file('res://scenes/title.tscn')
