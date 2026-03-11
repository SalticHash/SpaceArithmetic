extends Control

func _ready() -> void:
	for button: TextureButton in $Modes.get_children():
		button.pressed.connect(play.bind(button.name))
		button.is_hovered()

func play(game_mode: StringName) -> void:
	match game_mode:
		&"original": Global.game_mode = Global.GameModes.ORIGINAL
		&"timed": Global.game_mode = Global.GameModes.TIMED
		&"practice": Global.game_mode = Global.GameModes.PRACTICE
		&"vs":
			Global.game_mode = Global.GameModes.VS
			get_tree().change_scene_to_file.call_deferred("res://RootVS/RootVS.tscn")
			return
	get_tree().change_scene_to_file.call_deferred("res://Root/Root.tscn")

func _process(_delta: float) -> void:
	for button: TextureButton in $Modes.get_children():
		if !button.is_hovered(): continue
		hover(button.name)
		return
	$Desc.text = tr("hover_for_desc")

func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://Menu/Menu.tscn")

func hover(game_mode: String):
	$Desc.text = tr("mode_%s_desc" % game_mode)
