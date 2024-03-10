extends Sprite2D

enum STATE{
	FULL = 1,
	EMPTY = 0
}
var is_empty:bool = false
@export var refill_time:float
# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgressBar.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func empty():
	$TextureProgressBar.visible = true
	is_empty = true
	$TextureProgressBar/Timer.wait_time = refill_time/100
	frame = STATE.EMPTY
	$TextureProgressBar.value = 0
	$TextureProgressBar/Timer.start()
	print("empty")


func _on_timer_timeout():
	$TextureProgressBar.value += 1
	pass # Replace with function body.


func _on_texture_progress_bar_value_changed(value):
	if value >= 100:
		is_empty=false
		frame = STATE.FULL
		$TextureProgressBar.visible = false
	pass # Replace with function body.
