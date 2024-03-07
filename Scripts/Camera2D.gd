extends Camera2D

const PAN_SPEED = 200
var panning = false
var last_mouse_pos = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			panning = true
			last_mouse_pos = get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:
			panning = false
	if Input.is_action_just_pressed("ZoomIn"):
		if zoom < Vector2(4,4):
			zoom+=Vector2(0.5,0.5)
	if Input.is_action_just_pressed("ZoomOut"):
		if zoom > Vector2(0.5,0.5):
			zoom-=Vector2(0.3,0.3)

func _process(delta):
	if panning:
		var mouse_delta = get_global_mouse_position() - last_mouse_pos
		global_position -= mouse_delta * PAN_SPEED * delta
		last_mouse_pos = get_global_mouse_position()
