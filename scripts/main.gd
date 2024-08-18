extends Node2D

@onready var tile_scene = preload("res://scenes/tile.tscn")
@onready var game_tiles = $game_tiles
@onready var display_tilemap = $display_tilemap
@onready var organelle_tilemap = $organelle_tilemap

var mode = null
var active_tile = null
var active_organelle = null
var valid_placement = false

## Called when the node enters the scene tree for the first time.
func _ready():
	$waste_button/waste.play('default')
	$waste_button/waste.stop()
	for xi in range(6,11):
		for yi in range(2,7):
			var new_tile = tile_scene.instantiate()
			game_tiles.add_child(new_tile)
			new_tile.set_iposition(xi,yi)
			new_tile.position = Vector2(64+64*xi,64+64*yi)
	for tile in game_tiles.get_children():
		tile.tile_clicked.connect(_tile_clicked.bind(tile))
		tile.tile_entered.connect(_tile_entered.bind(tile))
	for xi in range(8,11):
		for yi in range(4,7):
			get_tile(Vector2i(xi,yi)).set_incel()
	for used_tile in display_tilemap.get_used_cells():
		set_display_tile(used_tile)
	_place_organelle(get_tile(Vector2i(8,4)),'nucleus')
	_place_organelle(get_tile(Vector2i(10,4)),'test1')
	if Global.controller: $expand_cell.grab_focus()

## Returns the tile scene with the given iposition vector
func get_tile(vector2i):
	for tile in game_tiles.get_children():
		if tile.get_iposition() == vector2i:
			return tile
	return null

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Helper function that removes organelle placement overlay
func _clear_organelle_tilemap():
	for cell in organelle_tilemap.get_used_cells():
		organelle_tilemap.set_cell(cell)

## Activates when any of the functional "game tiles" are clicked
func _tile_clicked(tile):
	if mode == 'expand':
		tile.set_incel()
	elif mode == 'shrink':
		if tile.get_organelle() == null:
			tile.set_incel(false)
	elif mode == 'organelle':
		if valid_placement:
			_place_organelle(tile,active_organelle)
			active_organelle = null
			mode = 'move'
			valid_placement = false
			_clear_organelle_tilemap()
	elif mode == 'move':
		if tile.organelle != null:
			active_organelle = _remove_organelle(tile)
			mode = 'organelle'
	for used_tile in display_tilemap.get_used_cells():
		set_display_tile(used_tile)

## Places given organelle with top left "origin" at given tile
func _place_organelle(tile,organelle):
	for vector2i in Global.get_organelle_vectors(organelle):
		get_tile(tile.get_iposition() + vector2i).set_organelle(organelle,tile.get_iposition())
	tile.show_organelle()

## Removes the organelle present at given tile
func _remove_organelle(tile):
	var origin_tile = get_tile(tile.get_organelle_origin())
	var organelle_to_remove = tile.get_organelle()
	for vector2i in Global.get_organelle_vectors(organelle_to_remove):
		var t = get_tile(origin_tile.get_iposition() + vector2i)
		t.set_organelle()
	origin_tile.hide_organelle()
	return organelle_to_remove

## Activates when the mouse hovers over a tile. Displays preview organelle in organelle mode
func _tile_entered(tile):
	_clear_organelle_tilemap()
	if mode == 'organelle':
		var affected_tiles = []
		var atlas_position = Global.get_organelle_atlas_position(active_organelle)
		var total_tiles = Global.get_organelle_vectors(active_organelle).size()
		for vector2i in Global.get_organelle_vectors(active_organelle):
			var t = get_tile(tile.get_iposition() + vector2i)
			if t != null:
				if t.get_incel() and t.get_organelle() == null:
					affected_tiles.append(vector2i)
		var atlas_id = 3
		valid_placement = false
		if affected_tiles.size() == total_tiles:
			atlas_id = 2
			valid_placement = true
		for vector2i in Global.get_organelle_vectors(active_organelle):
			organelle_tilemap.set_cell(tile.get_iposition()+vector2i,atlas_id,atlas_position+vector2i)

## Used to calculate which tile for the display tilemap to draw
func set_display_tile(vector2i):
	var game_tile_data = []
	for v2 in [Vector2i(-1,-1),Vector2i(0,-1),Vector2i(0,0),Vector2i(-1,0)]:
		if get_tile(vector2i + v2) == null:
			game_tile_data.append(0)
		else:
			game_tile_data.append(get_tile(vector2i + v2).get_id())
	display_tilemap.set_cell(vector2i,randi_range(0,1),Global.tilemap_key[game_tile_data])

## Handles all buttons
#region Buttons
## Activates when the debug "get organelle" button is pressed
func _on_get_organelle_pressed():
	mode = 'organelle'
	active_organelle = Global.random_organelle()

## Activates when the debug "expand cell" button is pressed
func _on_expand_cell_pressed():
	mode = 'expand'

## Activates when the debug "shrink cell" button is pressed
func _on_shrink_cell_pressed():
	mode = 'shrink'

## Activates when the debug "move organelle" button is pressed
func _on_move_organelle_pressed():
	mode = 'move'


## Handles the hazardous waste bin button
#region Waste Bin
func _on_waste_button_pressed():
	$waste_button/waste.play('trashed')
	active_organelle = null
	mode = 'move'

func _on_waste_animation_looped():
	if $waste_button.has_focus():
		$waste_button/waste.play('highlight')
	else:
		$waste_button/waste.play('default')
	$waste_button/waste.stop()


func _on_waste_button_focus_entered():
	$waste_button/waste.play('highlight')
	$waste_button/waste.stop()

func _on_waste_button_focus_exited():
	$waste_button/waste.play('default')
	$waste_button/waste.stop()


func _on_waste_button_mouse_entered():
	$waste_button/waste.play('hover')
	$waste_button/waste.stop()


func _on_waste_button_mouse_exited():
	if $waste_button/waste.animation != 'trashed':
		$waste_button/waste.play('default')
		$waste_button/waste.stop()
#endregion
#endregion

func _input(event):
	print(event.as_text())
	if event.is_action_type() && event.as_text() != "MOUSE_BUTTON_LEFT":
		if Global.controller:
			pass
		else:
			Global.controller = true
			$expand_cell.grab_focus()
	else:
		Global.controller = false
		get_viewport().gui_release_focus()
