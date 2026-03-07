extends Control

const locales_index = {
	"en": 0,
	"es": 1
}

func set_language(locale: String, setup: bool = false):
	TranslationServer.set_locale(locale)
	%DifLabel.text = get_dificulty(round(%DifSlider.value))
	%OpCount.text = tr("menu_timed_operation_count") % Global.get_timed_operation_count()
	if !setup:
		Preferences.saved.locale = locale
		Preferences.save_pr()
	else:
		%Locale.select(locales_index[Preferences.saved.locale])
		
	

func _ready() -> void:
	set_language(Preferences.saved.locale, true)
	_on_timed_duration_value_changed(Preferences.saved.timed_duration, true)
	_on_dif_slider_value_changed(Preferences.saved.difficulty, true)
	_on_screen_item_selected(Preferences.saved.window_mode, true)

	for operation in %Operations.get_children():
		if operation is not CheckBox: continue
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

func float_to_time(s: float) -> String:
	var seconds = int(s)
	var minutes = int(s / 60.0)
	seconds = seconds % 60
	return "%dm %02ds" % [minutes, seconds]

func _on_timed_duration_value_changed(value: float, setup: bool = false) -> void:
	%TimedDurationLabel.text = float_to_time(value)
	if !setup:
		Preferences.saved.timed_duration = value
		Preferences.save_pr()
	else:
		%TimedDuration.set_value_no_signal(value)

	
	%OpCount.text = tr("menu_timed_operation_count") % Global.get_timed_operation_count()

const dificulties = [
	"menu_dif_easier",
	"menu_dif_easy",
	"menu_dif_regular",
	"menu_dif_hard",
	"menu_dif_harder",
]
func get_dificulty(v: int) -> String:
	return tr(dificulties[v + 2])

func _on_dif_slider_value_changed(value: float, setup: bool = false) -> void:
	var v = roundi(value)
	%DifLabel.text = get_dificulty(v)
	if !setup:
		Preferences.saved.difficulty = v
		Preferences.save_pr()
	else:
		%DifSlider.set_value_no_signal(value)
	%OpCount.text = tr("menu_timed_operation_count") % Global.get_timed_operation_count()

func _on_screen_item_selected(index: int, setup: bool = false) -> void:
	if !setup:
		var mode = %Screen.get_item_id(index)
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN or \
			mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(mode)
		Preferences.saved.window_mode = mode
		Preferences.save_pr()
	else:
		var mode = index
		var idx = %Screen.get_item_index(mode)
		%Screen.select(idx)
		
