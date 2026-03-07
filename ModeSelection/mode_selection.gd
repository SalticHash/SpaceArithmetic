extends Control

func _ready() -> void:
	for button: TextureButton in $Modes.get_children():
		button.pressed.connect(play.bind(button.name))

func play(game_mode: String) -> void:
	match game_mode:
		"original": Global.game_mode = Global.GameModes.ORIGINAL
		"timed": Global.game_mode = Global.GameModes.TIMED
	get_tree().change_scene_to_file("res://Root/Root.tscn")


func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")
