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
		if $StateMachine.current_state.name != "Eat":
			$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position",velocity)
		$AnimationTree.set("parameters/Walk/blend_position",velocity)
		$AnimationTree.set("parameters/Eat/blend_position",velocity)
	move_and_slide()
	

