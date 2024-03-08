extends State
class_name Wonder
@export var wanderer_entity: CharacterBody2D
@export var move_speed:=10.0
var rest_time: float = 3
var move_direction: Vector2
var wonder_time: float

func randomize_wonder():
	move_direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	wonder_time = randf_range(1,2)
	

func Enter():
	randomize_wonder()
func Update(delta: float):
	
	if wanderer_entity.stamina <= 0:
		Trasitioned.emit(self,"Rest")
	elif wonder_time > 0:
		wonder_time -= delta
	else:
		wanderer_entity.stamina -= 1
		randomize_wonder()
	
func Physics_Update(delta: float):
	if wanderer_entity:
		wanderer_entity.velocity = move_direction * wanderer_entity.speed
		


func _on_detection_range_area_entered(area):
	print("walkto1")
	Trasitioned.emit(self,"WalkTo")
	pass # Replace with function body.
