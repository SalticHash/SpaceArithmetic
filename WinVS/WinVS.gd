extends Control

func _play_pressed():
	get_tree().change_scene_to_file.call_deferred("res://Menu/Menu.tscn")

func _ready():
	$Container/Time.text = tr("menu_win_time") % Global.time
	$Container/Label.text = tr("menu_vs_win_message") % Global.vs_winner
	$Container/Op1.text = tr("menu_vs_win_operations1") % Global.vs_op[0]
	$Container/Op2.text = tr("menu_vs_win_operations2") % Global.vs_op[1]


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://RootVS/RootVS.tscn")
