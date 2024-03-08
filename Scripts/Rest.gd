extends State
class_name Rest

@export var resting_entity: CharacterBody2D
var rest_time

func Enter():
	rest_time = 3
	resting_entity.velocity = Vector2.ZERO
	resting_entity.hunger += 1
	pass
func Exit():
	pass
func Update(delta:float):
	if rest_time > 0:
		rest_time -= delta
	else:
		resting_entity.stamina = resting_entity.max_stamina
		Trasitioned.emit(self,"Wonder")
	pass
func Physics_Update(delta:float):
	pass


func _on_detection_range_area_entered(area):
	print("walkto2")
	Trasitioned.emit(self,"WalkTo")
	pass # Replace with function body.
