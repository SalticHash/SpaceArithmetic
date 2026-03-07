extends Node2D
class_name Meteor
var health: int = 15
var velocity = Vector2.ZERO
var radius: float = 57.01
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var particle_textures: ResourcePreloader = $ParticleTextures
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var destroy_particles: GPUParticles2D = $DestroyParticles
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hit_sound: AudioStreamPlayer = $Hit
@onready var destroy_sound: AudioStreamPlayer = $Destroy
var accel: float = 0.15
var speed: float = -2.0
var hit_force: float = 6

var destructible: bool = false
var destroyed: bool = false
const SHIP_DISTANCE = 629.99
var color: StringName
var colors: Array[StringName] = [&"grey", &"brown"]
func _ready():
	if Global.game_mode == Global.GameModes.TIMED:
		destructible = true
		health = Global.get_timed_operation_count()
		speed = -SHIP_DISTANCE / Preferences.saved.timed_duration / 60.0
		accel = -speed
		hit_force = 0
	else:
		var dif = Preferences.saved.difficulty
		var mult = (dif + 4.0) / 4.0
		speed = mult * -2.0
		accel = mult * 0.15
		if dif == 1 or dif == 2:
			hit_force = 7
		#hit_force = 6 / mult
	
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
signal got_destroyed
func destroy():
	destroyed = true
	destroy_particles.restart()
	destroy_sound.play()
	sprite.hide()
	if destroy_particles.emitting:
		await destroy_particles.finished
	if destroy_sound.playing:
		await destroy_sound.finished
	got_destroyed.emit()

func hit(laser: Laser):
	animation.play("hit")
	laser.queue_free()
	velocity.x = hit_force
	health -= 1
	if health <= 0 and destructible:
		destroy()
		return
	hit_sound.play()
	hit_particles.restart()
