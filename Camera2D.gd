extends Camera2D

var max
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ZoomIn"):
		zoom += Vector2(0.1,0.1)
	if event.is_action_pressed("ZoomOut"):
		zoom -= Vector2(0.1,0.1)
	if event is InputEventMouseMotion and event.is_action_pressed("drag"):
		position -= event.relative*1.0 / zoom
