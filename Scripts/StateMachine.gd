extends Node

@export var initial_state: State
var current_state: State
var states: Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Trasitioned.connect(on_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.Update(delta)
func _physics_process(delta):	
	if current_state:
		current_state.Physics_Update(delta)
func on_transition(state, new_state_name):
	if state != current_state:
		return
	var new_state:State = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.Exit()
	new_state.Enter()
	current_state = new_state
	
