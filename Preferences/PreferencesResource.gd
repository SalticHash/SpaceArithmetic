extends Resource
class_name PreferencesResource

@export var locale: String = "none"
@export var operations: Dictionary[String, bool] = {
	"sum": true,
	"sub": false,
	"mul": false,
	"div": false
}
