extends Control

func _play_pressed():
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")

func _ready():
	$Container/Time.text = tr("menu_win_time") % Global.time
	$Container/Op.text = tr("menu_win_operations") % Global.op
