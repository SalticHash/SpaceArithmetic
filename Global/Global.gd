extends Node

var time := 0
var op := 0
var vs_winner: int = 0
var vs_op: Array[int] = [0,0]
enum GameModes {
	ORIGINAL,
	TIMED,
	PRACTICE,
	VS
}
var game_mode: GameModes

var multipliers = [0.25, 0.5, 1.0, 1.25, 1.5]
func get_timed_operation_count() -> int:
	var dur = Preferences.saved.timed_duration
	var dif = Preferences.saved.difficulty
	var mult = (dif + 4.0) / 4.0
	
	return round(dur * 0.75 * mult)
