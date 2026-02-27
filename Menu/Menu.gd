extends Control

func _play_pressed():
	get_tree().change_scene_to_file("res://Root/Root.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Settings/Settings.tscn")
