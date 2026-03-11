extends Control

func _play_pressed():
	get_tree().change_scene_to_file.call_deferred("res://Menu/Menu.tscn")


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://Root/Root.tscn")
