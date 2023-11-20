extends TileMap


# Called when the node enters the scene tree for the first time.
var seededFields = []
var dirtFields = []
var WheatCount = 0
var wslabel: Label
var dirtSound: AudioStreamPlayer
var harvestSound: AudioStreamPlayer
var plantSound: AudioStreamPlayer
var waterSound: AudioStreamPlayer
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func setWslabel(label:Label):
	wslabel = label
func setSounds( dirtSound1: AudioStreamPlayer,harvestSound1: AudioStreamPlayer,plantSound1: AudioStreamPlayer,waterSound1: AudioStreamPlayer):
	dirtSound = dirtSound1
	harvestSound=harvestSound1
	plantSound=plantSound1
	waterSound=waterSound1
func _input(event):
	if event.is_action_pressed("LeftClick"):
		var tile = local_to_map(get_global_mouse_position())
		print(get_cell_atlas_coords(1,tile),get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1)))
		#si es tierra arar
		if(get_cell_atlas_coords(1,tile) == Vector2i(0,0) or get_cell_atlas_coords(1,tile) == Vector2i(1,0)):
			arar(tile)
		#si es plantado regar
		else: if(get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1)) == Vector2i(4,0)):
			regar(tile)
		#si es cultivo recoger y poner tierra
		else: if(get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1)) == Vector2i(8,0)):
			cosechar(tile)
		#Si es arado plantar
		else: if(get_cell_atlas_coords(1,tile) == Vector2i(2,0)):
			sembrar(tile)
		

func arar(tile):
	dirtSound.play()
	set_cell(1,tile,1,Vector2(2,0),0)
	
func regar(tile):
	waterSound.play()
	seededFields.append({"TileID":Vector2(tile.x-1,tile.y-1),"GrowthState":0})
	set_cell(1,tile,1,Vector2(3,0),0)
	
func cosechar(tile):
	harvestSound.play()
	set_cell(1,tile,1,Vector2(1,0),0)
	dirtFields.append(tile)
	set_cell(0,Vector2(tile.x-1,tile.y-1),1,Vector2(-1,-1),0)
	WheatCount = WheatCount+16
	wslabel.text = str("%07d" % WheatCount)
func sembrar(tile):
	plantSound.play()
	set_cell(0,Vector2(tile.x-1,tile.y-1),1,Vector2(4,0),0)

func _on_wheat_timer_timeout():
	
	for seed in seededFields:
		print("growth")
		match seed["GrowthState"]:
			0:
				set_cell(0,seed["TileID"],1,Vector2(5,0),0)
				seed["GrowthState"] = seed["GrowthState"]+1
			1:
				set_cell(0,seed["TileID"],1,Vector2(6,0),0)
				seed["GrowthState"] = seed["GrowthState"]+1
			2:
				set_cell(0,seed["TileID"],1,Vector2(7,0),0)
				seed["GrowthState"] = seed["GrowthState"]+1
			3:
				set_cell(0,seed["TileID"],1,Vector2(8,0),0)
				seededFields.erase(seed)



func _on_grass_timer_timeout():
	for dirt in dirtFields:
		set_cell(1,dirt,1,Vector2(0,0),0)
		dirtFields.erase(dirt)
	pass # Replace with function body.
