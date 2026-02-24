extends Control

func _play_pressed():
	get_tree().change_scene_to_file("res://Root/Root.tscn")

func set_language(locale: StringName):
	TranslationServer.set_locale(locale)

@onready var lang_buttons: Array[Node] = $LanguageSelect.get_children()
func _ready() -> void:
	for lang_button: Button in lang_buttons:
		lang_button.pressed.connect(
			set_language.bind(lang_button.name)
		)
