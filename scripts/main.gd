extends Node2D

@onready var tile_scene = preload("res://scenes/tile.tscn")
@onready var game_tiles = $game_tiles
@onready var display_tilemap = $display_tilemap
@onready var organelle_tilemap = $organelle_tilemap
@onready var info_bar = $info_bar

var mode = null
var active_tile = null
var last_tile = null
var active_organelle = null
var valid_placement = false

## Called when the node enters the scene tree for the first time.
func _ready():
	for xi in range(2,7):
		for yi in range(1,6):
			var new_tile = tile_scene.instantiate()
			game_tiles.add_child(new_tile)
			new_tile.set_iposition(xi,yi)
			new_tile.position = Vector2(32+64*xi,96+64*yi)
	for tile in game_tiles.get_children():
		tile.tile_clicked.connect(_tile_clicked.bind(tile))
		tile.tile_entered.connect(_tile_entered.bind(tile))
	for xi in range(4,7):
		for yi in range(3,6):
			get_tile(Vector2i(xi,yi)).set_incel()
	for used_tile in display_tilemap.get_used_cells():
		set_display_tile(used_tile)
	_place_organelle(get_tile(Vector2i(4,3)),'nucleus')
	_place_organelle(get_tile(Vector2i(6,3)),'mitochondria')
	if Global.controller: $expand_cell.grab_focus()
	calculate_stats()

## Returns the tile scene with the given iposition vector
func get_tile(vector2i):
	for tile in game_tiles.get_children():
		if tile.get_iposition() == vector2i:
			return tile
	return null

func calculate_stats():
	var atp_modifier = 0
	var atk = 5
	var def = 2
	var heal = 2
	var crit = 0
	var scalar = 1.0
	for t in game_tiles.get_children():
		if t.get_incel():
			atp_modifier -= 10
			if t.get_organelle() == 'cellwall':
				def += 3
				for neighbor in _get_neighbors(t):
					if neighbor.get_organelle() == 'cellwall':
						def += 1
			elif t.get_organelle() == 'golgibody':
				atk += 5
			elif t.get_organelle() == 'mitochondria':
				for neighbor in _get_neighbors(t):
					if neighbor.get_organelle() != null:
						atp_modifier += 7
			elif t.get_organelle() == 'ribosome':
				heal += 5
			elif t.get_organelle() == 'endoplasmicreticulum':
				crit += 5
				for neighbor in _get_neighbors(t):
					if neighbor.get_organelle() == 'nucleus':
						crit += 5
			elif t.get_organelle() == 'proteinchannel':
				scalar += .6
				for neighbor in _get_neighbors(t):
					if neighbor.get_incel():
						scalar -= .15
	Global.set_stats([atp_modifier,atk,def,heal,crit,scalar])
	info_bar.set_display_stats(atp_modifier,atk,def,heal,crit,scalar)

## Returns an array including all adjacent tiles to the given tile
func _get_neighbors(tile):
	var neighbors = []
	for vector2i in [Vector2i(-1,0),Vector2i(0,-1),Vector2i(1,0),Vector2i(0,1)]:
		var neighbor = get_tile(tile.get_iposition()+vector2i)
		if neighbor != null:
			neighbors.append(neighbor)
	return neighbors

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
			_tile_entered(tile)
	for used_tile in display_tilemap.get_used_cells():
		set_display_tile(used_tile)
	calculate_stats()

## Places given organelle with top left "origin" at given tile
func _place_organelle(tile,organelle):
	for vector2i in Global.get_organelle_vectors(organelle):
		get_tile(tile.get_iposition() + vector2i).set_organelle(organelle,tile.get_iposition())
	tile.show_organelle()
	tile.set_organelle_stats(organelle)

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
	if Global.controller:
		$debug_overlay/get_organelle.release_focus()
		if last_tile != null: active_tile = last_tile
		else: active_tile = game_tiles.get_child(0)
		active_tile.selected()

## Activates when the debug "expand cell" button is pressed
func _on_expand_cell_pressed():
	mode = 'expand'
	if Global.controller:
		$debug_overlay/expand_cell.release_focus()
		if last_tile != null: active_tile = last_tile
		else: active_tile = game_tiles.get_child(0)
		active_tile.selected()

## Activates when the debug "shrink cell" button is pressed
func _on_shrink_cell_pressed():
	mode = 'shrink'
	if Global.controller:
		$debug_overlay/shrink_cell.release_focus()
		if last_tile != null: active_tile = last_tile
		else: active_tile = game_tiles.get_child(0)
		active_tile.selected()

## Activates when the debug "move organelle" button is pressed
func _on_move_organelle_pressed():
	mode = 'move'
	if Global.controller:
		$debug_overlay/move_organelle.release_focus()
		if last_tile != null: active_tile = last_tile
		else: active_tile = game_tiles.get_child(0)
		active_tile.selected()


## Handles the hazardous waste bin button
#region Waste Bin
func _on_waste_button_pressed():
	$debug_overlay/waste_button/waste.play('trashed')
	active_organelle = null
	mode = 'move'
	if Global.controller:
		$debug_overlay/waste_button.release_focus()
		if last_tile != null: active_tile = last_tile
		else: active_tile = game_tiles.get_child(0)
		active_tile.selected()

func _on_waste_animation_looped():
	if $debug_overlay/waste_button.has_focus():
		$debug_overlay/waste_button/waste.play('highlight')
	else:
		$debug_overlay/waste_button/waste.play('default')
	$debug_overlay/waste_button/waste.stop()


func _on_waste_button_focus_entered():
	$debug_overlay/waste_button/waste.play('highlight')
	$debug_overlay/waste_button/waste.stop()

func _on_waste_button_focus_exited():
	$debug_overlay/waste_button/waste.play('default')
	$debug_overlay/waste_button/waste.stop()


func _on_waste_button_mouse_entered():
	$debug_overlay/waste_button/waste.play('hover')
	$debug_overlay/waste_button/waste.stop()


func _on_waste_button_mouse_exited():
	if $debug_overlay/waste_button/waste.animation != 'trashed':
		$debug_overlay/waste_button/waste.play('default')
		$debug_overlay/waste_button/waste.stop()

func _on_select_button_pressed():
	#Assign $reward_screen.reward to something - is it the name of the reward as a string
	$reward_screen.hide()
#endregion
#endregion

func _input(event):
	if Global.controller:
		if event.as_text().contains("Mouse"):
			Global.controller = false
			get_viewport().gui_release_focus()
		elif  mode != null:
			if event.is_action_pressed("ui_cancel"):
				last_tile = active_tile
				active_tile.deselected()
				active_tile = null
				match mode:
					"expand":$debug_overlay/expand_cell.grab_focus()
					"shrink":$debug_overlay/shrink_cell.grab_focus()
					"organelle":$debug_overlay/get_organelle.grab_focus()
					"move":$debug_overlay/move_organelle.grab_focus()
				mode = null
				
			elif event.is_action_pressed("ui_up") && get_tile(active_tile.get_iposition() + Vector2i(0,-1)) != null:
				active_tile.deselected()
				active_tile = get_tile(active_tile.get_iposition() + Vector2i(0,-1))
				active_tile.selected()
				
			elif event.is_action_pressed("ui_down") && get_tile(active_tile.get_iposition() + Vector2i(0,1)) != null:
				active_tile.deselected()
				active_tile = get_tile(active_tile.get_iposition() + Vector2i(0,1))
				active_tile.selected()
				
			elif event.is_action_pressed("ui_left") && get_tile(active_tile.get_iposition() + Vector2i(-1,0)) != null:
				active_tile.deselected()
				active_tile = get_tile(active_tile.get_iposition() + Vector2i(-1,0))
				active_tile.selected()
				
			elif event.is_action_pressed("ui_right") && get_tile(active_tile.get_iposition() + Vector2i(1,0)) != null:
				active_tile.deselected()
				active_tile = get_tile(active_tile.get_iposition() + Vector2i(1,0))
				active_tile.selected()
	
	else:
		if !event.as_text().contains("Mouse"):
			Global.controller = true
			$debug_overlay/expand_cell.grab_focus()
