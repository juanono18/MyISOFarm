extends State
class_name Eat

@export var eating_entity: CharacterBody2D
@export var animationTree:AnimationTree
var point_pos:Vector2
var eat_time = 3

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
		Trasitioned.emit(self,"Wonder")
	pass
func Physics_Update(delta:float):
	pass
