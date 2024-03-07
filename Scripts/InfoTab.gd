extends Control
@export var entity:CharacterBody2D
@export var state_machine:Node
@onready var stamina_bar:ProgressBar = $Panel/VBoxContainer/StaminaBar
@onready var hunger_bar:ProgressBar = $Panel/VBoxContainer/HungerBar
@onready var state_label:Label = $Panel/VBoxContainer/StateLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	print( entity.hunger_capacity)
	if stamina_bar:
		stamina_bar.max_value = entity.max_stamina
		stamina_bar.value = stamina_bar.max_value
	if hunger_bar:
		hunger_bar.max_value = entity.hunger_capacity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stamina_bar.max_value >= 0:
		stamina_bar.max_value = entity.max_stamina
	stamina_bar.value = entity.stamina
	
	if entity.hunger != hunger_bar.value:
		hunger_bar.value = entity.hunger
	if state_machine:
		state_label.text = "state: " + str(state_machine.current_state.name)


func _input(event):
	if event.is_action_pressed("hotbar1"):
		visible = !visible


