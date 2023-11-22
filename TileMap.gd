extends TileMap


# Called when the node enters the scene tree for the first time.
var inventory={
	"money":0,
	"wheatSeed":5,
	"carrotSeed":0,
	"wheat":0,
	"carrot":0,
	"flour":0,
	"dirtBlock":2,
	"windmillBlock":2,
}
var selectedItemCursor="default"
var selectedItem
var crops={
	"grownState":{
	Vector2i(8,0):"wheat",
	Vector2i(14,0):"carrot"
}, "seedState":{
	Vector2i(4,0):"wheatSeed",
	"wheatSeed":Vector2i(4,0),
	Vector2i(10,0):"carrotSeed",
	"carrotSeed":Vector2i(10,0)
},
	"seedCursor":{
		"wheatSeed":"res://wheatseed_cursor.png",
		"carrotSeed":"res://carrotseed_cursor.png",
		"default":"res://seed_cursor.png"
	}
}
var tilesID = {
	"grass":Vector2i(0,0),
	"dirt":Vector2i(1,0),
	"hoed_dirt":Vector2i(2,0),
	"watered_dirt":Vector2i(3,0),
	"seeded_dirt":null,
	"grown_crop":Vector2i(14,0),
	"windmillBlock":Vector2i(16,0),
	"windmillBlock_place":Vector2i(22,0),
	"windmillBlockAnim":[Vector2i(16,0),Vector2i(17,0),Vector2i(18,0),Vector2i(19,0),Vector2i(20,0),Vector2i(21,0)]
}

var seededFields = []
var dirtFields = []
var windMill = []
var WheatCount = 0
var wslabel: Label
var dirtSound: AudioStreamPlayer
var harvestSound: AudioStreamPlayer
var plantSound: AudioStreamPlayer
var waterSound: AudioStreamPlayer
var prevTileBlock = null
var prevTile = null

func _ready():
	#$"../UI/inventoryButton".set_item_text(0,str("x%02d" % inventory["wheatSeed"]))
	#$"../UI/inventoryButton".set_item_text(1,str("x%02d" % inventory["carrotSeed"]))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateHoverOnTile()
	
func updateHoverOnTile():
	var tile = local_to_map(Vector2(get_global_mouse_position().x+5,get_global_mouse_position().y+10))
	if(get_cell_atlas_coords(1,tile) != Vector2i(-1,-1) and get_cell_atlas_coords(1,tile) != Vector2i(15,0)):
		
		if( get_cell_atlas_coords(1,tile) == tilesID["grass"] or  get_cell_atlas_coords(1,tile) == tilesID["dirt"]):
			Input.set_custom_mouse_cursor(load("res://hoe_cursor.png"))
		elif( get_cell_atlas_coords(0,Vector2i(tile.x-1,tile.y-1)) in crops["seedState"]):
			Input.set_custom_mouse_cursor(load("res://water_cursor.png"))
		elif( get_cell_atlas_coords(1,tile) == tilesID["hoed_dirt"]):	
			Input.set_custom_mouse_cursor(load(crops["seedCursor"][selectedItemCursor]))
		elif(get_cell_atlas_coords(0,Vector2i(tile.x-1,tile.y-1)) in crops["grownState"]):
			Input.set_custom_mouse_cursor(load("res://harvest_cursor.png"))
		if selectedItem != null and inventory[selectedItem]>=1 and selectedItem in tilesID:
			set_cell(2,Vector2(tile.x-1,tile.y-1),1,tilesID[selectedItem+"_place"],0)
		else:
			set_cell(2,Vector2(tile.x-1,tile.y-1),1,Vector2i(9,0),0)
	else:
		
		if selectedItem == "dirtBlock" and inventory["dirtBlock"]>=1:
			Input.set_custom_mouse_cursor(load("res://default_cursor.png"))
			set_cell(1,tile,1,Vector2i(15,0),0)
		else:
			Input.set_custom_mouse_cursor(load("res://default_cursor.png"))
	if(prevTile != null):
		if(tile != prevTile):
			set_cell(2,Vector2(prevTile.x-1,prevTile.y-1))
			
	if(prevTileBlock != null):
		if(tile != prevTileBlock and get_cell_atlas_coords(1,prevTileBlock) == Vector2i(15,0)):
			#print(prevTile)
			set_cell(1,prevTileBlock,1,Vector2i(-1,-1),0)
	prevTile = tile
	prevTileBlock = tile
	
func setWslabel(label:Label):
	wslabel = label
	
func setSounds( dirtSound1: AudioStreamPlayer,harvestSound1: AudioStreamPlayer,plantSound1: AudioStreamPlayer,waterSound1: AudioStreamPlayer):
	dirtSound = dirtSound1
	harvestSound=harvestSound1
	plantSound=plantSound1
	waterSound=waterSound1
	
func _unhandled_input(event):
	if event.is_action_pressed("LeftClick"):
		var tile = local_to_map(Vector2(get_global_mouse_position().x+5,get_global_mouse_position().y+10))
		#print(get_cell_atlas_coords(1,tile),get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1)))
		if(selectedItem != null and inventory[selectedItem]>=1 and selectedItem in tilesID):
			inventory[selectedItem] -= 1
			set_cell(1,tile,1,tilesID["grass"],0)
			set_cell(0,Vector2(tile.x-1,tile.y-1),1,tilesID["windmillBlock"],0)
			windMill.append([Vector2(tile.x-1,tile.y-1),0,false])
		#si es tierra arar
		elif(get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1)) in tilesID["windmillBlockAnim"]):
			var index = 0
			for mill in windMill:
					if mill[0] == Vector2(tile.x-1,tile.y-1):
						
						break
					index+=1
			if inventory["wheat"] >= 1 and !windMill[index][2]:
				inventory["wheat"]-=1
				windMill[index][2]=true
				$"../UI/Container/MenuShop".updateInventory()
				
				
					
				
		elif(get_cell_atlas_coords(1,tile) == tilesID["grass"] or get_cell_atlas_coords(1,tile) == tilesID["dirt"]):
			arar(tile)
		#si es plantado regar
		elif(get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1)) in crops["seedState"]):
			regar(tile)
		#si es cultivo recoger y poner tierra
		elif(get_cell_atlas_coords(0,Vector2i(tile.x-1,tile.y-1)) in crops["grownState"]):
			cosechar(tile)
		#Si es arado plantar
		elif(get_cell_atlas_coords(1,tile) == tilesID["hoed_dirt"]):
			sembrar(tile)
		elif(get_cell_atlas_coords(1,tile) == Vector2i(15,0) and inventory["dirtBlock"]>=1):
			dirtSound.play()
			dirtFields.append(tile)
			inventory["dirtBlock"] -= 1
			set_cell(1,tile,1,tilesID["dirt"],0)
			$"../UI/Container/MenuShop".updateInventory()
			
	if event.is_action_pressed("RightClick"):
		var tile = local_to_map(Vector2(get_global_mouse_position().x+5,get_global_mouse_position().y+10))
		if(get_cell_atlas_coords(1,tile) != Vector2i(-1,-1) and get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1)) == Vector2i(-1,-1) and get_cell_atlas_coords(1,tile) != Vector2i(15,0)):
			if get_cell_atlas_coords(1,tile) == tilesID["grass"]:
				set_cell(1,tile,1, Vector2i(-1,-1),0)
				set_cell(2,Vector2(tile.x-1,tile.y-1))
				inventory["dirtBlock"]+=1
				$"../UI/Container/MenuShop".updateInventory()
			else:
				set_cell(1,tile,1,tilesID["grass"],0)
		

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

	var currentCrop = crops["grownState"][get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1))]
	inventory[currentCrop] += 8
	print(str(currentCrop)+": "+str(inventory[currentCrop]))
	set_cell(0,Vector2(tile.x-1,tile.y-1),1,Vector2(-1,-1),0)
	$"../UI/Container/MenuShop".updateInventory()
func sembrar(tile):
	
	if tilesID["seeded_dirt"] != null and inventory[crops["seedState"][tilesID["seeded_dirt"]]] > 0:
		plantSound.play()
		set_cell(0,Vector2(tile.x-1,tile.y-1),1,tilesID["seeded_dirt"],0)
		var currentCrop = crops["seedState"][get_cell_atlas_coords(0,Vector2(tile.x-1,tile.y-1))]
		inventory[currentCrop] -= 1
		$"../UI/Container/MenuShop".updateInventory()
	else:
		$"../Sounds/denied".play()

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

func _on_animation_timer_timeout():
	for mill in windMill:
		var tile = get_cell_atlas_coords(1,mill[0])
		var frame = tilesID["windmillBlockAnim"]
		if(mill[2]):
			match mill[1]:
				0:
					set_cell(0,mill[0],1,frame[1],0)
					mill[1] = mill[1]+1
				1:
					set_cell(0,mill[0],1,frame[2],0)
					mill[1] = mill[1]+1
				2:
					set_cell(0,mill[0],1,frame[3],0)
					mill[1] = mill[1]+1
				3:
					set_cell(0,mill[0],1,frame[4],0)
					mill[1] = mill[1]+1
				4:
					set_cell(0,mill[0],1,frame[1],0)
					mill[1] = mill[1]+1
				5:
					set_cell(0,mill[0],1,frame[2],0)
					mill[1] = mill[1]+1
				6:
					set_cell(0,mill[0],1,frame[3],0)
					mill[1] = mill[1]+1
				7:
					set_cell(0,mill[0],1,frame[4],0)
					mill[1] = mill[1]+1
				8:
					set_cell(0,mill[0],1,frame[5],0)
					mill[1] = 0
					inventory["flour"]+=1
					$"../UI/Container/MenuShop".updateInventory()
					mill[2]=false
		#var tile = get_cell_atlas_coords(0,seed["TileID"])
	
		pass # Replace with function body.
	


func setSelectedItem(id):
		selectedItem = id
		if id in crops["seedState"]:
			tilesID["seeded_dirt"] = crops["seedState"][id]
			if crops["seedCursor"][id] != null:
				selectedItemCursor = id
		else:
			selectedItemCursor="default"
			tilesID["seeded_dirt"] = null
		
func setInventory(inv):
	inventory=inv
func getInventory():
	return inventory


