extends Node

var master_volume = 1
var music_volume = .5
var effects_volume = .5
var volume_scale = 1

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
