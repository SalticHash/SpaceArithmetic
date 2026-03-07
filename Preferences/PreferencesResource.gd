extends Resource
class_name PreferencesResource

@export var locale: String = "none"
@export var operations: Dictionary[String, bool] = {
	"sum": true,
	"sub": false,
	"mul": false,
	"div": false
}
@export var timed_duration: float = 24.0
@export var difficulty: int = 0
@export var window_mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_WINDOWED
