extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_start():
	pass
	#$Settings/MusicVolumeSlider.value = Global.music_volume
	#$Settings/SoundEffectsVolumeSlider.value = Global.effects_volume


#Button Pressing Logic
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

#Slider Logic
func master_volume_changed(value):
	Global.master_volume = value
func music_volume_changed(value):
	Global.music_volume = value
func effects_volume_changed(value):
	Global.effects_volume = value
