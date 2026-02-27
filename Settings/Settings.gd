extends Control

const locales_index = {
	"en": 0,
	"es": 1
}

func set_language(locale: String):
	TranslationServer.set_locale(locale)
	Preferences.saved.locale = locale
	Preferences.save_pr()
	

func _ready() -> void:
	%Locale.select(locales_index[Preferences.saved.locale])
	set_language(Preferences.saved.locale)
	for operation: CheckBox in %Operations.get_children():
		var op: String = operation.name
		var active: bool = Preferences.saved.operations[op]
		operation.set_pressed_no_signal(active)
		operation.toggled.connect(operation_toggled.bind(op))

func operation_toggled(toggled: bool, op: String) -> void:
	Preferences.saved.operations[op] = toggled
	Preferences.save_pr()

func _on_locale_selected(index: int) -> void:
	set_language(locales_index.keys()[index])

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")
