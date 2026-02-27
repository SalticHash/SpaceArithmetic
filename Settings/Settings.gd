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
		operation.toggled.connect(operation_toggled.bind(operation))

func operation_toggled(toggled: bool, button: CheckBox) -> void:
	var selected = Preferences.saved.operations.values().count(true)
	if toggled == false:
		if selected == 0:
			print("How did you unpress all of them?")
			var sum = $Alignment/Operations/sum
			sum.set_pressed_no_signal(true)
			operation_toggled(true, sum)
		if selected == 1:
			button.set_pressed_no_signal(true)
			return
	Preferences.saved.operations[button.name] = toggled
	Preferences.save_pr()

func _on_locale_selected(index: int) -> void:
	set_language(locales_index.keys()[index])

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")
