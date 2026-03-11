extends Sprite2D
class_name Laser
var radius: float = 23.0
var color: StringName
func _ready() -> void:
	match color:
		&"red": frame = 0
		&"orange": frame = 1
		&"green": frame = 2
		&"blue": frame = 3

func _process(delta):
	position.x += 20 * delta * 60 * scale.x
