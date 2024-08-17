extends Node2D

@onready var tile_scene = preload("res://scenes/tile.tscn")
@onready var game_tiles = $game_tiles
@onready var display_tilemap = $display_tilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	for xi in range(0,4):
		for yi in range(0,4):
			var new_tile = tile_scene.instantiate()
			game_tiles.add_child(new_tile)
			new_tile.set_iposition(xi,yi)
			new_tile.position = Vector2(64+64*xi,64+64*yi)
	for tile in game_tiles.get_children():
		tile.tile_clicked.connect(_tile_clicked.bind(tile))

func get_tile(vector2i):
	for tile in game_tiles.get_children():
		if tile.get_iposition() == vector2i:
			return tile
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _tile_clicked(tile):
	tile.set_incel()
	for used_tile in display_tilemap.get_used_cells():
		set_display_tile(used_tile)

func set_display_tile(vector2i):
	var game_tile_data = []
	for v2 in [Vector2i(-1,-1),Vector2i(0,-1),Vector2i(0,0),Vector2i(-1,0)]:
		if get_tile(vector2i + v2) == null:
			game_tile_data.append(0)
		else:
			game_tile_data.append(get_tile(vector2i + v2).get_id())
	display_tilemap.set_cell(vector2i,randi_range(0,1),Global.tilemap_key[game_tile_data])
