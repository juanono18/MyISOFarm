extends TileMap


# Called when the node enters the scene tree for the first time.
var grownState={
	Vector2i(8,0):true,
	Vector2i(14,0):true
}
var seedState={
	Vector2i(4,0):true,
	Vector2i(10,0):true
}
var tilesID = {
	"grass":Vector2i(0,0),
	"dirt":Vector2i(1,0),
	"hoed_dirt":Vector2i(2,0),
	"watered_dirt":Vector2i(3,0),
	"seeded_dirt":Vector2i(10,0),
	"grown_crop":Vector2i(14,0)
}
var seededFields = []
var dirtFields = []
var WheatCount = 0
var wslabel: Label
var dirtSound: AudioStreamPlayer
var harvestSound: AudioStreamPlayer
var plantSound: AudioStreamPlayer
var waterSound: AudioStreamPlayer
var prevTile
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateHoverOnTile()
	
func updateHoverOnTile():
	var tile = local_to_map(Vector2(get_global_mouse_position().x+5,get_global_mouse_position().y+10))
	if(get_cell_atlas_coords(1,tile) != Vector2i(-1,-1)):
		if( get_cell_atlas_coords(1,tile) == tilesID["grass"] or  get_cell_atlas_coords(1,tile) == tilesID["dirt"]):
			Input.set_custom_mouse_cursor(load("res://hoe_cursor.png"))
		elif( get_cell_atlas_coords(0,Vector2i(tile.x-1,tile.y-1)) in seedState):
			Input.set_custom_mouse_cursor(load("res://water_cursor.png"))
		elif( get_cell_atlas_coords(1,tile) == tilesID["hoed_dirt"]):
			Input.set_custom_mouse_cursor(load("res://seed_cursor.png"))
		elif(get_cell_atlas_coords(0,Vector2i(tile.x-1,tile.y-1)) in grownState):
			Input.set_custom_mouse_cursor(load("res://harvest_cursor.png"))
		set_cell(2,Vector2(tile.x-1,tile.y-1),1,Vector2i(9,0),0)
	if(prevTile != null):
		#print("here")
		if(tile != prevTile):
			#print(prevTile)
			set_cell(2,Vector2(prevTile.x-1,prevTile.y-1))
	prevTile = tile
	
func setWslabel(label:Label):
	wslabel = label
	
func setSounds( dirtSound1: AudioStreamPlayer,harvestSound1: AudioStreamPlayer,plantSound1: AudioStreamPlayer,waterSound1: AudioStreamPlayer):
	dirtSound = dirtSound1
	harvestSound=harvestSound1
	plantSound=plantSound1
	waterSound=waterSound1
	
func _input(event):
	if event.is_action_pressed("hotbar1"):
		tilesID["seeded_dirt"]= Vector2i(4,0)
		tilesID["grown_crop"]=Vector2i(8,0)
	if event.is_action_pressed("hotbar2"):
		tilesID["seeded_dirt"]= Vector2i(10,0)
		tilesID["grown_crop"]=Vector2i(14,0)
	if event.is_action_pressed("LeftClick"):
		var tile = local_to_map(Vector2(get_global_mouse_position().x+5,get_global_mouse_position().y+10))
		#print(get_cell_atlas_coords(1,tile),get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1)))
		#si es tierra arar
		if(get_cell_atlas_coords(1,tile) == tilesID["grass"] or get_cell_atlas_coords(1,tile) == tilesID["dirt"]):
			arar(tile)
		#si es plantado regar
		elif(get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1)) in seedState):
			regar(tile)
		#si es cultivo recoger y poner tierra
		elif(get_cell_atlas_coords(0,Vector2i(tile.x-1,tile.y-1)) in grownState):
			cosechar(tile)
		#Si es arado plantar
		elif(get_cell_atlas_coords(1,tile) == tilesID["hoed_dirt"]):
			sembrar(tile)
		

func arar(tile):
	dirtSound.play()
	set_cell(1,tile,1,tilesID["hoed_dirt"],0)
	
func regar(tile):
	waterSound.play()
	seededFields.append({"TileID":Vector2(tile.x-1,tile.y-1),"GrowthState":0})
	set_cell(1,tile,1,tilesID["watered_dirt"],0)
	
func cosechar(tile):
	harvestSound.play()
	set_cell(1,tile,1,tilesID["dirt"],0)
	dirtFields.append(tile)
	set_cell(0,Vector2(tile.x-1,tile.y-1),1,Vector2(-1,-1),0)
	WheatCount = WheatCount+16
	wslabel.text = str("%07d" % WheatCount)
func sembrar(tile):
	plantSound.play()
	set_cell(0,Vector2(tile.x-1,tile.y-1),1,tilesID["seeded_dirt"],0)

func _on_wheat_timer_timeout():
	
	for seed in seededFields:
		#print("growth")
		var tile = get_cell_atlas_coords(0,seed["TileID"])
		match seed["GrowthState"]:
			0:
				set_cell(0,seed["TileID"],1,Vector2(tile.x+1,tile.y),0)
				seed["GrowthState"] = seed["GrowthState"]+1
			1:
				set_cell(0,seed["TileID"],1,Vector2(tile.x+1,tile.y),0)
				seed["GrowthState"] = seed["GrowthState"]+1
			2:
				set_cell(0,seed["TileID"],1,Vector2(tile.x+1,tile.y),0)
				seed["GrowthState"] = seed["GrowthState"]+1
			3:
				set_cell(0,seed["TileID"],1,Vector2(tile.x+1,tile.y),0)
				seededFields.erase(seed)



func _on_grass_timer_timeout():
	for dirt in dirtFields:
		if(get_cell_atlas_coords(1,dirt) != tilesID["dirt"]):
			dirtFields.erase(dirt)
		else:
			set_cell(1,dirt,1,tilesID["grass"],0)
			dirtFields.erase(dirt)
	pass # Replace with function body.
