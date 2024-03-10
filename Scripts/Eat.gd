extends State
class_name Eat

@export var eating_entity: CharacterBody2D
@export var animationTree:AnimationTree
var point_pos:Vector2
var eat_time = 1
var food_comp

func Enter():
	
	pass
func Exit():
	pass
func Update(delta:float):
	if eat_time > 0:
		animationTree.get("parameters/playback").travel("Eat")
		eat_time -= delta
	else:
		eat_time = 3
		eating_entity.hunger = 0
		if food_comp.has_method("empty"):
			food_comp.empty()
		Trasitioned.emit(self,"Wonder")
	pass
func Physics_Update(delta:float):
	pass


func _on_close_range_area_entered(area):
	#print("entered")
	food_comp =area.get_parent()
	
	pass # Replace with function body.
