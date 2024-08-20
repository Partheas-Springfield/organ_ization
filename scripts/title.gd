extends Node2D

var last_box = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the sliders' values based on the global values
	for player in $MusicPlayer.get_children():player.volume_db = linear_to_db(Global.music_volume*Global.volume_scale)
	last_box = $TitleBox/Start
	if Global.controller: $TitleBox/Start.grab_focus()
	_play_music(Global.track_save, Global.music_save)
	Global.track_save="title"
	Global.music_save=0.0
	
func on_start():
	if$MusicPlayer/TitleMusic.playing:Global.music_save = $MusicPlayer/TitleMusic.get_playback_position()
	get_tree().change_scene_to_file('res://scenes/main.tscn')


#region Button Pressing Logic
func on_settings(): 
	$TitleBox.hide()
	$Title_Cover.show()
	$Settings.show()
	$Settings/Back.grab_focus()
func on_instructions():
	$TitleBox.hide()
	$Title_Cover.show()
	$Instructions.show()
	$Instructions/Back.grab_focus()
func on_credits():
	$TitleBox.hide()
	$Title_Cover.show()
	$Credits.show()
	$Credits/Back.grab_focus()
func on_settings_back():
	$TitleBox.show()
	$Title_Cover.hide()
	$Settings.hide()
	$TitleBox/SettingsButton.grab_focus()
func on_instructions_back():
	$TitleBox.show()
	$Title_Cover.hide()
	$Instructions.hide()
	$TitleBox/InstructionsButton.grab_focus()
func on_credits_back():
	$TitleBox.show()
	$Title_Cover.hide()
	$Credits.hide()
	$TitleBox/CreditsButton.grab_focus()
#endregion

#region Settings Logic
func _master_volume_changed(value):
	Global.master_volume = value
func _music_volume_changed(value):
	Global.music_volume = value
	print(Global.music_volume)
	for player in $MusicPlayer.get_children():player.volume_db = linear_to_db(Global.music_volume*Global.volume_scale)
func _effects_volume_changed(value):
	Global.effects_volume = value
	
func _on_music_select_item_selected(index):
	for player in $MusicPlayer.get_children(): player.stop()
	match index:
		0:$MusicPlayer/TitleMusic.play()
		1:$MusicPlayer/BuildTheme.play()
		2:$MusicPlayer/BattleTheme.play()
		3:$MusicPlayer/ComingForYou.play()
		
func _on_disable_toggle_toggled(toggled):
	Global.force_controller=toggled
	match toggled:
		true:$Settings/DisableToggle.text = "Forced"
		false:$Settings/DisableToggle.text = "Auto"
#endregion


func _input(event):
	if Global.controller:
		if event.as_text().contains("Mouse")&&!Global.force_controller:
			Global.controller = false
			last_box = get_viewport().gui_get_focus_owner()
			if last_box!=null:last_box.release_focus()
	else:
		if !event.as_text().contains("Mouse"):
			Global.controller = true
			if last_box!=null:last_box.grab_focus()
			else:
				if $Settings.is_visible_in_tree():$Settings/Back.grab_focus()
				elif $Instructions.is_visible_in_tree():$Instructions/Back.grab_focus()
				elif $Credits.is_visible_in_tree():$Credits/Back.grab_focus()
				else:$Start.grab_focus()
			get_viewport().set_input_as_handled()


func _play_music(track="stop", time=0.0):
	for player in $MusicPlayer.get_children():player.stop()
	match track:
		"build":$MusicPlayer/BuildTheme.play(time)
		"battle":$MusicPlayer/BattleTheme.play(time)
		"title":$MusicPlayer/TitleMusic.play(time)
		"C4Y":$MusicPlayer/ComingForYou.play(time)
func _on_title_music_finished():
	$MusicPlayer/TitleMusic.play()
func _on_build_theme_finished():
	$MusicPlayer/BuildTheme.play()
func _on_battle_theme_finished():
	$MusicPlayer/BattleTheme.play()
