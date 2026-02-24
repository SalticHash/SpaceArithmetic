extends Node2D
class_name Player
var radius: float = 37.0
@onready var game: Game = get_tree().current_scene
@onready var shoot_sound: AudioStreamPlayer = $ShootSound

const packed_laser: PackedScene = preload("res://Laser/Laser.tscn")
func shoot():
	var laser = packed_laser.instantiate()
	shoot_sound.play()
	laser.global_position = global_position
	game.lasers.add_child(laser)
