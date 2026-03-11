extends Control

func _play_pressed():
	get_tree().change_scene_to_file.call_deferred("res://ModeSelection/ModeSelection.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://Settings/Settings.tscn")
