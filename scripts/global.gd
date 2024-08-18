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

func get_organelle_hp(organelle):
	return organelle_stat_dict[organelle][0]

func random_organelle():
	var i = randi_range(0,organelle_list.size()-1)
	return organelle_list[i]

func get_organelle_vectors(organelle):
	return shape_dict[organelle]

func get_organelle_atlas_position(organelle):
	return organelle_tilemap_dict[organelle]
