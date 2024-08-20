extends Node

var master_volume = 1
var music_volume = .5
var effects_volume = .5
var volume_scale = 2
var music_save = 0.0
var track_save = "title"

var stats = [0,5,0,0,0,0]
var held_organelle = null
var held_organelle_hp = null
var battle_won = false
var level = 0.

var controller = false
var force_controller = false

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

const all_organelle_text = "If the NUCLEUS is destroyed, the cell will die. Be careful!

The GOLGI BODY increases attack power.

The MITOCHONDRIA is the powerhouse of the cell! When placed adjacent to other organelles,the mitochondria will reduce ATP upkeep.

The CELL WALL boosts defense, increasing with adjacent CELL WALL pieces.

The RIBOSOME boosts cell recovery, allowing the repair of damaged organelles.

The ENDOPLASMIC RETICULUM will speed things up in the cell, especially when placed next to the NUCLEUS. It grants double speed chance, allowing powerful double attacks, defense boosts, and heals!

The PROTEIN CHANNEL enables the cell to exchange materials with the nutrient-rich environment. It grants bonuses to all stats except double speed chance for every adjacent tile not in the cell."

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
	"CEO Shelly",
	"Dr. Vicky",
	"CEO Shelly",
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
	"CEO Shelly",
	"Inga",
	"Dr. Vicky",
	"CEO Shelly",
	"Inga",
	"CEO Shelly",
]
const intro_text = [
	"Congratulations Dr. Fraulenstein, not many people get their own lab at your age.",
	"Thank you, Mrs Shelly. This is a dream come true.",
	"Well Vicky, you deserve it. This revolutionary new Crisp-st cell modifier you made could change the world.",
	"Yes with the right modifications, I hope to create a new type of superimmune cell. Perhaps we could cure diseases, extend life, maybe even raise the d-",
	"*grunt*",
	"Wait, who is this?",
	"Oh that's just Inga, your new lab assistant!",
	"*grunt* [Hello, nice to meet you, Dr. Fraulenstein.]",
	"Oh, um, hello Inga, you can just call me Vicky. Is she... okay?",
	"No, she's a grad student. She comes with the lab. In their semi-conscious caffeine fueled state they can pretty much only make grunting noises, but at least they don’t need money, sleep or rights. You can usually figure out what the grunts mean.",
	"*grunt* [The inequities of our society can only be addressed by proletarian rule]",
	"Didn't quite catch that one. Anyway, good luck!",
]
#endregion
#region First Build Text
const build_speaker = [
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
	"Inga",
	"Inga",
	"Dr. Vicky",
	"Inga",
]
const build_text = [
	"Let's get started making a superimmune cell, Inga. Did you set up Crisp-st?",
	"*grunt* [According to your specifications.]",
	"Go ahead and show me your lab setup.",
	"*grunt* [On the left, we have the empty proto-cell. On the right we have the cell building tools. Grow or shrink the cell with cytoplasm, then place organelles in the cell from the bank.]",
	"Anything I do to the cell will affect the cell's abilities",
	"*grunt* [You can see the resulting stats above]",
	"If this cell is going to be superimmune, I'll need to pack as many useful organelles as I can into the smallest area of cytoplasm. I should start with the Nucleus, the cell won't function without it.",
	"*grunt* [You will probably want to keep as many organelles as possible, but if you need to get rid of one just use the hazardous waste bin in the corner.]",
	"*grunt* [Once you're done placing the organelles and sculpting the cell, your system should bring it to life when you proceed to trial.]",
	"Okay, got it. Thanks for all your help, Inga",
	"*grunt* [I look forward to seeing the results of your work.]",
]
#endregion
#region Post First Build Phase
const post_build_speaker = [
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
	"Inga",
	"Card",
	"Scene",
	"Inga",
]

const post_build_text = [
	"It’s alive! Thank you for your help, Inga.",
	"*grunt* [My pleasure, Vicky.]",
	"This specimen looks promising, let’s keep it for observation for now.",
	"*grunt* [Will do. I will see you tomorrow.]",
	"That Evening", #Night time lab scene
	"Cell POV, inga backlit, looming sinister", #Art
	"So, this is the cell that Vicky is so excited about becoming superimmune? You don’t look so tough. Let’s see if you can survive this.",
]
#endregion
#region First Battle Text
const battle_speaker = [
	"Cell",
	"Cell",
	"Cell",
	"Cell",
]
const battle_text = [
	"Threats, Viruses. Their marks appear.",
	"I sense them targeting my organelles",
	"I must use my ATP to fight",
	"Consume them and grow!",
]
#endregion
#region Post First Battle Phase
const post_battle_speaker = [
	"Card",
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
]

const post_battle_text = [
	"The Next Day",
	"Inga, this is incredible! The specimen has somehow developed new capacity overnight.",
	"*grunt* [So it survived and got stronger? Congratulations Vicky.]",
	"I could probably modify it further now. But I wonder what triggered this change?",
	"*grunt* [Who knows, maybe you should make those modifications though, next time it may not be so lucky.]",
	"Good idea, let’s get to work. A few more rounds of this and we'll have a superimmune cell in no time.",
]
#endregion
#region Win
const win_speaker = [
	#"Scene",
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
	"Scene",
	"Scene",
	"Dr. Vicky",
	"Scene",
	"Scene",
	"Card",
	"Card",
]
const win_text = [
	#"The lab",
	"Wow, this cell is so powerful now, I’m not sure anything could kill it, Inga!",
	"Yes, I was hoping to quietly eliminate it before this point.",
	"Wait, what? You can talk? Also you were plotting to destroy the specimen?",
	"Your work is too powerful to be left in the hands of this company. Now that it’s come to this, I’ll just have to steal it!",
	"No! You can’t!",
	"Struggle in the lab, the petri dish slips and breaks by the open door.", #dish break art
	"Containment Breach sign lights up", #art
	"It's growing and multiplying!",
	"Vicky and Inga look up in horror as the shadow of the mass towers towers over them",
	"The silhouette of a city skyline covered in goo",
	"Dr. Vicky Fraulenstein’s superimmune monster. You have become the dominant lifeform on earth, completely immune to death.",
	"Congratulations!",
]
#endregion
#region Loss
const loss_speaker = [
	"Dr. Vicky",
	"Inga",
	"Dr. Vicky",
	"Inga",
	"Scene",
]
const loss_text = [
	"Oh no! What happened?",
	"*grunt* [Sorry, Vicky. It seems the specimen was too weak to survive the night. Perhaps we should consider a different use for Crisp-st.]",
	"No, Inga. I’m more determined than ever now. Next time I will make a Cell that truly changes the world!",
	"*grunt* [Then I will be here to contribute too.]",
	"The lab, Vicky tearful, Inga comforting somewhat insincerely",
]
#endregion
#region Credits
const credits=[
	"Project Lead: Anneke van Renesse",
	"Programming: Anneke van Renesse, Patrick Mayville",
	"Story Design: Justin Sun, Hayley/betrayalis",
	"Writing: Justin Sun",
	"Art: Hayley/betrayalis, Anneke van Renesse",
	"Music & Sound Design: Justin Sun, Anneke van Renesse",
	"Vocal Performance: Justin Sun",
	"Brainstorming, Playtesting, and General Support: Adam Holder, MatthewCole Waschezyn"
]
#endregion

#endregion
