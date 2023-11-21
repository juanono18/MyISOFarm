extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	#add_item($PopupMenu)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	$"../../Sounds/openinv".play()
	pass # Replace with function body.
