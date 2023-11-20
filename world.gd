extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ParallaxBackground/AnimatedSprite2D.play()
	$TileMap.setWslabel($UI/WheatScore/Score)
	$TileMap.setSounds($Sounds/hoe,$Sounds/harvest,$Sounds/plant,$Sounds/watering)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

