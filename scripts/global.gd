extends Node

var master_volume = 1
var music_volume = .5
var effects_volume = .5
var volume_scale = 2

var stats = [0,5,0,0,0,0]
var held_organelle = null
var held_organelle_hp = null
var battle_won = false
var level = 0.

var controller = false

const organelle_list = ['nucleus','ribosome','mitochondria','golgibody','proteinchannel','endoplasmicreticulum','cellwall']

const tilemap_key = {
	[0,0,0,0]: Vector2i(0,3),
	[1,0,0,0]: Vector2i(3,3),
	[0,1,0,0]: Vector2i(0,2),
	[0,0,1,0]: Vector2i(1,3),
	[0,0,0,1]: Vector2i(0,0),
	[1,1,0,0]: Vector2i(1,2),
	[1,0,1,0]: Vector2i(0,1),
	[1,0,0,1]: Vector2i(3,2),
	[0,1,1,0]: Vector2i(1,0),
	[0,1,0,1]: Vector2i(2,3),
	[0,0,1,1]: Vector2i(3,0),
	[1,1,1,0]: Vector2i(2,2),
	[1,1,0,1]: Vector2i(3,1),
	[1,0,1,1]: Vector2i(2,0),
	[0,1,1,1]: Vector2i(1,1),
	[1,1,1,1]: Vector2i(2,1),
}

const organelle_info_dict = {
	'ribosome' : 'The RIBOSOME boosts cell recovery, allowing the repair of damaged organelles.',
	'mitochondria' : 'The MITOCHONDRIA is the powerhouse of the cell! When placed adjacent to other organelles,the mitochondria will reduce ATP upkeep.',
	'golgibody' : 'The GOLGI BODY increases attack power.',
	'nucleus' : 'If the NUCLEUS is destroyed, the cell will die. Be careful!',
	'proteinchannel' : 'The PROTEIN CHANNEL enables the cell to exchange materials with the nutrient-rich environment. It grants bonuses to all stats except double speed chance for every adjacent tile not in the cell.',
	'endoplasmicreticulum' : 'The ENDOPLASMIC RETICULUM will speed things up in the cell, especially when placed next to the NUCLEUS. It grants double speed chance, allowing powerful double attacks, defense boosts, and heals!',
	'cellwall' : 'The CELL WALL boosts defense, increasing with adjacent CELL WALL pieces.'
}

const organelle_icon_path_dict = {
	'ribosome' : 'res://sprites/organelle_icon1.png',
	'mitochondria' : 'res://sprites/organelle_icon2.png',
	'golgibody' : 'res://sprites/organelle_icon3.png',
	'nucleus' : 'res://sprites/organelle_icon4.png',
	'proteinchannel' : 'res://sprites/organelle_icon6.png',
	'endoplasmicreticulum' : 'res://sprites/organelle_icon5.png',
	'cellwall' : 'res://sprites/organelle_icon7.png'
}

const shape_dict = {
	'ribosome' : [Vector2i(0,0)],
	'mitochondria' : [Vector2i(0,0),Vector2i(0,1)],
	'golgibody' : [Vector2i(0,0),Vector2i(1,0)],
	'nucleus' : [Vector2i(0,0),Vector2i(0,1),Vector2i(1,0),Vector2i(1,1)],
	'proteinchannel' : [Vector2i(0,0),Vector2i(0,1),Vector2i(0,2)],
	'endoplasmicreticulum' : [Vector2i(0,0),Vector2i(1,0),Vector2i(2,0)],
	'cellwall' : [Vector2i(0,0)]
}

const organelle_tilemap_dict = {
	'ribosome' : Vector2i(0,0),
	'mitochondria' : Vector2i(0,1),
	'golgibody' : Vector2i(1,0),
	'nucleus' : Vector2i(1,1),
	'proteinchannel' : Vector2i(3,0),
	'endoplasmicreticulum' : Vector2i(0,3),
	'cellwall' : Vector2i(3,3)
}

const organelle_stat_dict = {
	'ribosome' : [50],
	'mitochondria' : [50],
	'golgibody' : [50],
	'nucleus' : [150],
	'proteinchannel' : [50],
	'endoplasmicreticulum' : [50],
	'cellwall' : [100]
}

const organelle_name_dict = {
	'ribosome' : 'RIBOSOME',
	'mitochondria' : 'MITOCHONDRIA',
	'golgibody' : 'GOLGI BODY',
	'nucleus' : 'NUCLEUS',
	'proteinchannel' : 'PROTEIN CHANNEL',
	'endoplasmicreticulum' : 'ENDOPLASMIC RETICULUM',
	'cellwall' : 'CELL WALL'
}

## Organelle bounding size in "tiles"
const organelle_size_dict = {
	'ribosome' : Vector2(1,1),
	'mitochondria' : Vector2(1,2),
	'golgibody' : Vector2(2,1),
	'nucleus' : Vector2(2,2),
	'proteinchannel' : Vector2(1,3),
	'endoplasmicreticulum' : Vector2(3,1),
	'cellwall' : Vector2(1,1)
}

func get_organelle_info(organelle):
	return organelle_info_dict[organelle]

func get_organelle_hp(organelle):
	return organelle_stat_dict[organelle][0]

func random_organelle():
	var i = randi_range(1,organelle_list.size()-1)
	return organelle_list[i]

func get_organelle_name(organelle):
	return organelle_name_dict[organelle]

func get_organelle_vectors(organelle):
	return shape_dict[organelle]

func get_organelle_atlas_position(organelle):
	return organelle_tilemap_dict[organelle]

func set_stats(stat_array):
	stats = stat_array

func get_icon_path(organelle):
	return organelle_icon_path_dict[organelle]

func get_organelle_from_icon_path(path):
	for key in organelle_icon_path_dict:
		if organelle_icon_path_dict[key] == path:
			return key
	return null

#region Cutscene Text Information

#region Intro
const intro_speaker = [
	"Shelly",
	"Vicky",
	"Shelly",
	"Vicky",
	"Inga",
	"Vicky",
	"Shelly",
	"Inga",
	"Vicky",
	"Shelly",
	"Inga",
	"Shelly",
]
const intro_text = [
	"Congratulations Dr. Fraulenstein, not many people get their own lab at your age.",
	"Thank you, Mrs Shelly. This is a dream come true.",
	"Well Vicky, you deserve it. This revolutionary new Crisp-st cell modifier you made could change the world.",
	"Yes with the right modifications, I hope to create a new type of superimmune cell. Perhaps we could cure diseases, extend life, maybe even raise the d-",
	"*grunt*",
	"Wait, who is this?",
	"Oh that's just Inga, your new lab assistant!",
	"*grunt* [Hello, nice to meet you, Dr. Fraulenstein]",
	"Oh, um, hello Inga, you can just call me Vicky. Is she... okay?",
	"No, she's a grad student. She comes with the lab. In their semi-conscious caffeine fueled state they can pretty much only make grunting noises, but at least they don’t need money, sleep or rights. You can usually figure out what the grunts mean.",
	"*grunt* [The inequities of our society can only be addressed by proletarian rule]",
	"Didn't quite catch that one. Anyway, good luck!",
]
#endregion
#region Build Text
const build_speaker = [
	"Vicky",
	"Inga",
	"Vicky",
	"Inga",
	"Vicky",
	"Inga",
	"Vicky",
	"Inga",
	"Vicky",
	"Inga",
	"Inga",
]
const build_text = [
	"Alright, let's set up the Crisp-st cell in this petri dish.",
	"*grunts* [Do you know how to use this equipment?]",
	"Honestly, I feel a little disoriented in the new lab. I'd really appreciate a quick breakdown.",
	"*grunts* [Sure thing, Vicky. As you've probably noticed, all of our tools are laid out on the right side of the petri dish.]",
	"I see that these top two will let me make the cell larger or smaller.",
	"*grunts* [That's right. Larger cells can hold more organelles, but use more ATP just to survive.]",
	"Right. Cells with more organelles are more powerful, but smaller cells have more ATP to interact with their environment.",
	"*grunts* [Precisely. Try to make your cell just big enough to fit the organelles you want.]",
	"And this last thing must be the organelle bank. I just have to move organelles from here onto open spots in the cell.",
	"*grunts* [You can also store existing cells there, or put them in the biohazard bin in the corner. I'll deal with the waste immediately.]",
	"*grunts* [Make sure you get the Nucleus in there! The cell won't function without it...]",
]
#endregion
#region Post First Build Phase
const post_build_speaker = [
	"Vicky",
	"Inga",
	"Vicky",
	"Inga",
	#"Card",
	#"Scene",
	"Inga",
]

const post_build_text = [
	"It’s alive! Thank you for your help, Inga.",
	"*grunt* [My pleasure, Vicky]",
	"This specimen looks promising, let’s keep it for observation for now.",
	"*grunt* [Will do. I will see you tomorrow.]",
	#"That Evening",
	#"Cell POV, inga backlit, looming sinister",
	"So, this is the cell that Vicky is so excited about becoming superimmune? You don’t look so tough. Let’s see if you can survive this.",
]
#endregion
#region Post First Battle Phase
const post_battle_speaker = [
	"Vicky",
	"Inga",
	"Vicky",
	"Inga",
	"Vicky",
]

const post_battle_text = [
	"Inga, this is incredible! The specimen has somehow developed new ATP capacity overnight.",
	"*grunt* [So it survived and got stronger? Congratulations Vicky.]",
	"I could probably modify it further now. But I wonder what triggered this change?",
	"*grunt* [Who knows, maybe you should make those modifications though, next time it may not be so lucky.]",
	"Good idea, let’s get to work.",
]
#endregion
#region Win
const win_speaker = [
	#"Scene",
	"Vicky",
	"Inga",
	"Vicky",
	"Inga",
	"Vicky",
	#"Scene",
	#"Scene",
	#"Scene",
	#"Scene",
	#"Scene",
	#"Card",
	#"Card",
]
const win_text = [
	#"The lab",
	"Wow, this cell is so powerful now, I’m not sure anything could kill it, Inga!",
	"Yes, I was hoping to quietly eliminate it before this point.",
	"Wait, what? You can talk? Also you were plotting to destroy the specimen?",
	"Your work is too powerful to be left in the hands of this company. Now that it’s come to this, I’ll just have to steal it!",
	"No! You can’t!",
	#"Struggle in the lab, the petri dish slips and breaks by the open door.",
	#"Containment Breach sign lights up",
	#"An expanding mass of goo",
	#"Vicky and Inga look up in horror as the shadow of the mass towers towers over them",
	#"The silhouette of a city skyline covered in goo",
	#"Dr. Fraulenstein’s superimmune monster. You have become the dominant lifeform on earth, completely immune to death.",
	#"Congratulations!",
]
#endregion
#region Loss
const loss_speaker = [
	#"Scene",
	"Vicky",
	"Inga",
	"Vicky",
	"Inga"
]
const loss_text = [
	#"The lab, Vicky tearful, Inga comforting somewhat insincerely",
	"Oh no! What happened?",
	"*grunt* [Sorry, Vicky. It seems the specimen was too weak to survive the night. Perhaps we should consider a different use for Crisp-st]",
	"No, Inga. I’m more determined than ever now. Next time I will make a Cell that truly changes the world!",
	"*grunt* [Then be here to contribute too.]",
]
#endregion
#region Credits
const credits=[
	"Project Lead: Anneke van Renesse",
	"Programming: Anneke van Renesse, Patrick Mayville",
	"Story Design: Justin Sun, Hayley/betrayalis",
	"Writing: Justin Sun",
	"Sprites: Anneke van Renesse",
	"Portraits and Backgrounds: Hayley/betrayalis",
	"\"Coming for You\": Justin Sun",
	"Brainstorming, Playtesting, and General Support: Adam Holder, MatthewCole Waschezyn",
]
#endregion

#endregion
