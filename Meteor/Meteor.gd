extends Node2D
class_name Meteor
var health: int = 10
var velocity = Vector2.ZERO
var radius: float = 57.01
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var particle_textures: ResourcePreloader = $ParticleTextures
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var destroy_particles: GPUParticles2D = $DestroyParticles
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hit_sound: AudioStreamPlayer = $Hit
@onready var destroy_sound: AudioStreamPlayer = $Destroy
#var accel: float = 0.15
#var speed: float = -2.0
#var hit_force: float = 6

var destructible: bool = true
var destroyed: bool = false
var accel: float = 0.15
var speed: float = -0.5
var hit_force: float = 2
var color: StringName
var colors: Array[StringName] = [&"grey", &"brown"]
func _ready():
	color = colors.pick_random()
	sprite.animation = color
	hit_particles.texture = \
		particle_textures.get_resource("hit_" + color)
	destroy_particles.texture = \
		particle_textures.get_resource("destroy_" + color)
	sprite.frame = randi_range(0, 3)

func _process(delta):
	if destroyed: return
	hit_particles.global_position = global_position
	rotate(speed / 100 * delta * 60)
	position.x += velocity.x * delta * 60
	velocity.x = move_toward(velocity.x, speed, accel * delta * 60)

func destroy():
	destroyed = true
	destroy_particles.restart()
	destroy_sound.play()
	sprite.hide()

func hit(laser: Laser):
	animation.play("hit")
	laser.queue_free()
	velocity.x = hit_force
	health -= 1
	if health < 0 and destructible:
		destroy()
		return
	hit_sound.play()
	hit_particles.restart()
