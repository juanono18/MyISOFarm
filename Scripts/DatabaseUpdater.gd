extends Control


@export var db_item: PackedScene
@onready var grid_container: GridContainer = $VBoxContainer/ScrollContainer/GridContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	# Check if the tileset is valid
	var f = FileAccess.open("res://DataBase/db.json", FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(f.get_as_text())
	var db:Dictionary = json_object.get_data()
	var tileset = load("res://Scenes/tileset.tres")
	
	if tileset and tileset is TileSet:
		# Retrieve tile size

		var tss : TileSetSource = tileset.get_source(1)
		for t in tss.get_tiles_count():
			#item_list.add_item(str(tss.get_tile_id(t)))
			
				
			var instance = db_item.instantiate()
			var lbl:Label = instance.get_child(0)
			var txt:TextEdit = instance.get_child(1)
			lbl.text = str(tss.get_tile_id(t))
			for key in db.keys():
				if  db[key] == str(tss.get_tile_id(t)):
					txt.text= key
					txt.editable = false
			grid_container.add_child(instance)
			print(tss.get_tile_id(t))
		

	
	else:
		print("Failed to load tileset.")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var db = {}
	for i in grid_container.get_children():
		if "dbItem" in i.get_groups():
			var lbl:Label = i.get_child(0)
			var txt:TextEdit = i.get_child(1)
			db[txt.text] = lbl.text
	print(db)

	var json_string = JSON.stringify(db)

	var file_path = "res://DataBase/db.json"  


	var file = FileAccess.open(file_path, FileAccess.WRITE)

	file.store_string(json_string)

	file.close()
	pass # Replace with function body.
