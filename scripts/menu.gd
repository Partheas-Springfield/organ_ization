extends Node2D

@export var MusicPlayer = AudioStreamPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func open():
	$DisableToggle.set_pressed_no_signal(Global.force_controller)
	$VolumeControls/MusicVolumeSlider.value = Global.music_volume
	$VolumeControls/SoundEffectsVolumeSlider.value = Global.effects_volume
	show()

#region Settings Logic
func _music_volume_changed(value):
	Global.music_volume = value
	$MusicPlayer.volume_db = linear_to_db(Global.music_volume*Global.volume_scale)
func _effects_volume_changed(value):
	Global.effects_volume = value
func _on_disable_toggle_toggled(toggled):
	Global.force_controller=toggled
	match toggled:
		true:$DisableToggle.text = "Forced"
		false:$DisableToggle.text = "Auto"
#endregion


func _on_give_up_pressed():
	get_tree().change_scene_to_file('res://scenes/title.tscn')


func _on_return_pressed():
	hide()
