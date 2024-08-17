extends Node

var master_volume = 1
var music_volume = .5
var effects_volume = .5
var volume_scale = 1

const organelle_list = ['test1','test2','test3','nucleus','rna','test4','cellwall']

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
	'test1' : [Vector2i(0,0)],
	'test2' : [Vector2i(0,0),Vector2i(0,1)],
	'test3' : [Vector2i(0,0),Vector2i(1,0)],
	'nucleus' : [Vector2i(0,0),Vector2i(0,1),Vector2i(1,0),Vector2i(1,1)],
	'rna' : [Vector2i(0,0),Vector2i(0,1),Vector2i(0,2)],
	'test4' : [Vector2i(0,0),Vector2i(1,0),Vector2i(2,0)],
	'cellwall' : [Vector2i(0,0)]
}

const organelle_tilemap_dict = {
	'test1' : Vector2i(0,0),
	'test2' : Vector2i(0,1),
	'test3' : Vector2i(1,0),
	'nucleus' : Vector2i(1,1),
	'rna' : Vector2i(3,0),
	'test4' : Vector2i(0,3),
	'cellwall' : Vector2i(3,3)
}

func random_organelle():
	var i = randi_range(0,organelle_list.size()-1)
	return organelle_list[i]

func get_organelle_vectors(organelle):
	return shape_dict[organelle]

func get_organelle_atlas_position(organelle):
	return organelle_tilemap_dict[organelle]
