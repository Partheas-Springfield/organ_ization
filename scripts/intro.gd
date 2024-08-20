extends Node2D

@export var focus_send = Control.new() ## Which UI element to make grab_focus() when cutscenes end
var paused = false
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
	%Story.text = "[fade start=" + str(fade) + " length=1]" + text_list[story_index]
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !paused:
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

func start(input=scene):
	scene=input
	$TitleMusic.volume_db=linear_to_db(Global.music_volume*Global.volume_scale)
	match scene:
		1: #intro>post first build
			speaker_list=Global.post_build_speaker
			text_list=Global.post_build_text
		2: #post first build>post first fight
			speaker_list=Global.post_battle_speaker
			text_list=Global.post_battle_text
		3: #loss
			speaker_list=Global.loss_speaker
			text_list=Global.loss_text
			$TitleMusic.play()
		4: #win
			speaker_list=Global.win_speaker
			text_list=Global.win_text
			$TitleMusic.play()
		_:pass
	show()
	$Nameplate.text=speaker_list[0]
	$Portrait.play(speaker_list[story_index])
	paused=false

func skip_press():
	if scene == 0:$BrightLab.show()
	else:_advance()

func skip_down():
	#%Skip.text = ":("
	pass

func _on_next_pressed():
	if fade<text_list[story_index].length(): fade=text_list[story_index].length()
	elif story_index<text_list.size()-1&&story_index<speaker_list.size()-1:
		story_index+=1
		fade = fade_start
		$Nameplate.text = "[center]" + speaker_list[story_index]
		$Portrait.play(speaker_list[story_index])
		match $Nameplate.text:
			"[center]Card":
				$Nameplate.hide()
				$Portrait.hide()
				%Story.show()
				$TempSplash.set_position(Vector2(8,392))
				$TempSplash.set_size(Vector2(1072,216))
			"[center]Scene":
				fade=1000
				$Nameplate.hide()
				$Portrait.hide()
				%Story.hide()
				$TempSplash.set_position(Vector2(8,552))
				$TempSplash.set_size(Vector2(1072,56))
			_:
				$Nameplate.show()
				$Portrait.show()
				%Story.show()
				$TempSplash.set_position(Vector2(8,392))
				$TempSplash.set_size(Vector2(1072,216))
		_adjust_background()
	elif scene==0:
		$BrightLab.show()
	else: _advance()
	
#region Microscope Logic
func _on_microscope_pressed():
	$BrightLab.hide()
	_advance()
func _on_microscope_focus_entered():
	$BrightLab/Microscope/Image2.show()
func _on_microscope_focus_exited():
	$BrightLab/Microscope/Image2.hide()
#endregion

func _advance():
	scene+=1
	story_index=0
	_adjust_background()
	paused=true
	fade=fade_start
	match scene:
		4:
			$GameOverScreen.switch("loss")
		5:
			$TitleMusic.stop()
			$GameOverScreen.switch()
		_:
			hide()
			if Global.controller:focus_send.grab_focus()
"""
func _input(event):
	if !is_visible_in_tree()||$GameOverScreen.is_visible_in_tree():pass
	elif Global.controller:
		if event.as_text().contains("Mouse")&&!Global.force_controller:
			Global.controller = false
			get_viewport().gui_release_focus()
	else:
		if !event.as_text().contains("Mouse"):
			Global.controller = true
			if$BrightLab.is_visible_in_tree():$BrightLab/Microscope.grab_focus()
			else:$Next.grab_focus()
			get_viewport().set_input_as_handled()
	if scene==0:
		if event.as_text().contains("Mouse"):$BrightLab/Banner/MicroscopeLabel.text = "[center]Click the microscope to begin!"
		elif event.as_text().contains("Joypad"):$BrightLab/Banner/MicroscopeLabel.text = "[center]Press \"A\" to begin!"
		else: $BrightLab/Banner/MicroscopeLabel.text = "[center]Press \"space\" to begin!"
"""

func _adjust_background():
	match scene:
		1:
			match story_index:
				4:
					$Backgrounds/Lab_Night.show()
				5:
					$Backgrounds/Lab_Night.hide()
					$Backgrounds/Inga_Looming.show()
				6:
					$Nameplate.text="Inga"
					$Nameplate.show()
		2:$Backgrounds/Inga_Looming.hide()
		3:# Loss
			match story_index:
				4:$Backgrounds/VickyCrying.show()
		4:# Win
			match story_index:
				5:
					$Backgrounds/BrokenGlass.show()
					$Shatter.volume_db=linear_to_db(Global.effects_volume*Global.volume_scale)
					$Shatter.play()
				6:
					$Backgrounds/BrokenGlass.hide()
					$Backgrounds/CBSign.show()
					$Backgrounds/CBSign.play()
					$Klaxon.volume_db=linear_to_db(Global.effects_volume*Global.volume_scale)
					$Klaxon.play()
				8:
					$Backgrounds/CBSign.hide()
					$Backgrounds/LookingUp.show()
				9:
					$Backgrounds/LookingUp.hide()
					$Backgrounds/GooLine.show()
					

func _on_title_music_finished():
	$TitleMusic.play()


func _on_title_music_tree_exiting():
	if scene==4:Global.music_save=$TitleMusic.get_playback_position()
