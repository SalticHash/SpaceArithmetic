extends Node2D
class_name Meteor

var velocity = Vector2.ZERO
var radius: float = 57.01
@onready var sprite: AnimatedSprite2D = $Sprite

func _ready():
	sprite.frame = randi_range(0, 3)

func _process(delta):
	rotate(velocity.x / 100 * delta * 60)
	position.x += velocity.x * delta * 60
	if velocity.x > -2:
		velocity.x -= 0.15 * delta * 60
	

func hit(laser: Laser):
	$AnimationPlayer.play("hit")
	laser.queue_free()
	velocity.x = 6
