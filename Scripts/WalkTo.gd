extends State
class_name WalkTo

@export var moving_entity: CharacterBody2D
var point_pos:Vector2

func Enter():

	pass
func Exit():
	pass
func Update(delta:float):

	pass
func Physics_Update(delta:float):
	# This input will need to be created in the input map
	
	# Calculate the target position
	var target_position = (point_pos - moving_entity.position).normalized()
 
	# Check if the player is in a 3px range of the click position, if not move to the target position
	if moving_entity.position.distance_to(point_pos) > 3:
		moving_entity.velocity = target_position * moving_entity.speed
	else:
		moving_entity.velocity = Vector2.ZERO
		Trasitioned.emit(self,"Eat")

func _on_detection_range_area_entered(area):
	print(area.position)
	point_pos = area.get_parent().position
	pass # Replace with function body.


