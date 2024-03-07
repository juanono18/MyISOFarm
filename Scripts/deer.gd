extends CharacterBody2D

@export var speed:int
@export var stamina:int
@export var hunger_capacity:int
@export var tile_map:TileMap

var hunger:int = 0
@onready var max_stamina:int = stamina
# Get the gravity from the project settings to be synced with RigidBody nodes.
func _ready():
	pass
func _physics_process(delta):
	if hunger >= hunger_capacity:
		queue_free()
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position",velocity)
		$AnimationTree.set("parameters/Walk/blend_position",velocity)
		$AnimationTree.set("parameters/Eat/blend_position",velocity)
	move_and_slide()
	

#not ideal
func _on_detection_range_area_entered(area):
	tile_map.empty_bush(area.position)
	pass # Replace with function body.
