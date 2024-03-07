extends Node2D

var local_pos: Vector2i
var tile_type
var tile_map:TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_map = get_parent()
	print(local_pos,tile_type)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("hey")
	pass
	


