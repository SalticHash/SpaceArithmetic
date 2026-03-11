extends Node2D
class_name Player
var radius: float = 37.0
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var stun_timer: Timer = $StunTimer
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var game: Node = get_tree().current_scene
@onready var shoot_sound: AudioStreamPlayer = $ShootSound
@onready var malfunct_shot_sound: AudioStreamPlayer = $MalfunctShotSound
const colors: Array[StringName] = [
	&"red", &"orange", &"green", &"blue"
]
var color: StringName
var stunned: bool = false
func _ready() -> void:
	color = colors.pick_random()
	sprite.animation = color
	sprite.frame_progress = randf()

var packed_laser: PackedScene = load("res://Laser/Laser.tscn")
func shoot():
	if stunned: return
	var laser = packed_laser.instantiate()
	shoot_sound.play()
	animation.stop()
	animation.play("shoot")
	laser.global_position = global_position
	laser.color = color
	laser.scale = scale
	game.lasers.add_child(laser)

var malfunction_count = 0
func malfunct_shot():
	if stunned: return
	malfunct_shot_sound.play()
	malfunction_count += 1
	if malfunction_count >= 3 and Global.game_mode != Global.GameModes.PRACTICE:
		malfunction_count = 0
		stun()
		return
	animation.stop()
	animation.play("malfunct_shot")

signal got_stunned
func stun():
	if stunned: return
	stunned = true
	animation.stop()
	animation.play("stun")
	stun_timer.start()
	got_stunned.emit()

func stun_end():
	stunned = false
	animation.play("RESET")
	
