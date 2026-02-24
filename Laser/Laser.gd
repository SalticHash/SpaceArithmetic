extends Node2D
class_name Laser
var radius: float = 23.0

func _process(delta):
	position.x += 20 * delta * 60
