extends Control

func _play_pressed():
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")

func _ready():
	$Container/Time.text = 'Tiempo: ' + str(Global.time) + 's'
	$Container/Op.text = 'Operaciones: ' + str(Global.op)
