extends TileMap

# Called when the node enters the scene tree for the first time.
@export var tileScript:Script
@onready var db_handler:dbHandler = dbHandler.new()
var previous_mouse_position: Vector2i
var select_layer:int

func _ready():
	db_handler._ready()
	for i in range(get_layers_count()):
		if get_layer_name(i) == "selector":
			select_layer = i
	load_tiles()
func _process(delta):
	# Update the shader time parameter

	pass
	
func _input(event):
	var mouse_pos: Vector2 = get_global_mouse_position()/scale
	var tile_mouse_pos: Vector2i = local_to_map(mouse_pos)
	if Input.is_action_just_pressed("LeftClick"):
		#print(mouse_pos)
		var tile_data:TileData = get_cell_tile_data(0,tile_mouse_pos)
		
		if tile_data:
			if tile_data.get_custom_data("plowable"):
				print("I can be plowed")
				plow(tile_mouse_pos)
	if event is InputEventMouseMotion:
		if tile_mouse_pos != previous_mouse_position:
			selector_placement(tile_mouse_pos)
		
func plow(tile):
	print("plowed")
	set_cell(0,tile,1,db_handler.getCoords("mowed_dirt"))
	
#Handles the placment of the selector square tile
func selector_placement(tile_mouse_pos):
	if get_cell_atlas_coords(0,tile_mouse_pos) != Vector2i(-1,-1):
		set_cell(select_layer,tile_mouse_pos,1,db_handler.getCoords("selector"))
	set_cell(select_layer,previous_mouse_position,1,Vector2i(-1,-1))
	previous_mouse_position = tile_mouse_pos

#necesita mejoras
func load_tiles():
	var scene = preload("res://Scenes/location.tscn")
	var map_size = get_used_cells(1)
	for cell:Vector2i in map_size:
		
		if get_cell_atlas_coords(1,cell) == db_handler.getCoords("bush_full"):
			print(db_handler.getCellName(get_cell_atlas_coords(1,cell)))
			var instance = scene.instantiate()
			instance.position = map_to_local(cell)
			add_child(instance)

#not ideal
func empty_bush(global_position):
	var local_position = local_to_map(global_position)
	set_cell(1,local_position,1,db_handler.getCoords("bush"))
