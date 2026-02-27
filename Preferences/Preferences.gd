extends Node

const SAVE_PATH = "user://preferences.tres"
var saved: PreferencesResource

func _ready() -> void:
	load_pr()
	if Preferences.saved.locale not in TranslationServer.get_loaded_locales():
		var default_locale: String = OS.get_locale()
		var best_score: int = 0
		var best_locale: String = "us"
		for loaded_locale in TranslationServer.get_loaded_locales():
			var score: int = TranslationServer.compare_locales(default_locale, loaded_locale)
			if score >= best_score:
				best_score = score
				best_locale = loaded_locale
		Preferences.saved.locale = best_locale
		save_pr()
	TranslationServer.set_locale(saved.locale)

func create_pr() -> void:
	print("Creating preferences...")
	saved = PreferencesResource.new()
	save_pr()

func save_pr() -> void:
	print("Saving preferences...")
	var error_code = ResourceSaver.save(saved, SAVE_PATH)
	if error_code == OK: return
	push_error("Failed to save preferences: " + error_string(error_code))

func load_pr() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		create_pr()
		return
	
	print("Loading game...")
	Engine.print_error_messages = false
	saved = ResourceLoader.load(SAVE_PATH, "PreferencesResource", ResourceLoader.CACHE_MODE_REPLACE)
	Engine.print_error_messages = true
	if saved == null:
		print("Failed to load preferences!")
		create_pr()
		return
