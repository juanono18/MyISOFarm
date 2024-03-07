extends Node
class_name dbHandler
var db = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	var f = FileAccess.open("res://DataBase/db.json", FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(f.get_as_text())
	db = json_object.get_data()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass
func getCoords(name:String):
	var components = db[name].replace("(","").replace(")","").replace(",","").split(' ')
	return Vector2i(int(components[0]),int(components[1]))
	
func getCellName(atlas:Vector2i):
	return find_key_by_value(str(atlas))
	
func find_key_by_value(target_value):
	for key in db.keys():
		if db[key] == target_value:
			return key
	return null 
