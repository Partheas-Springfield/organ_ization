extends Node

var master_volume = 1
var music_volume = .5
var effects_volume = .5
var volume_scale = 1

var controller = false

const organelle_list = ['ribosome','mitochondria','golgibody','nucleus','proteinchannel','endoplasmicreticulum','cellwall']

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

func get_organelle_hp(organelle):
	return organelle_stat_dict[organelle][0]

func random_organelle():
	var i = randi_range(0,organelle_list.size()-1)
	return organelle_list[i]

func get_organelle_vectors(organelle):
	return shape_dict[organelle]

func get_organelle_atlas_position(organelle):
	return organelle_tilemap_dict[organelle]

#region Text Information

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

#endregion
