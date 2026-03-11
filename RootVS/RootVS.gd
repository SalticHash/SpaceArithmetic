extends Node
class_name GameVS

@onready var meteor: Meteor = $World/Meteor
@onready var players: Array[Player] = [$World/Player1, $World/Player2]
@onready var lasers: Node2D = $World/Lasers
@onready var exit_position: float = 1240.0 - meteor.radius
#----------------Utility Functions----------------#



func xcollision(a: Node2D, b: Node2D) -> bool:
	if !a or !b: return false
	return abs(a.global_position.x - b.global_position.x) \
		 < abs(a.radius + b.radius)
#-------------------------------------------------#
var answer1 := 0
var answer2 := 0

@onready var inputs1 = [
	%'Numpad1/Row3/0',
	%'Numpad1/Row2/1',
	%'Numpad1/Row2/2',
	%'Numpad1/Row2/3',
	%'Numpad1/Row1/4',
	%'Numpad1/Row1/5',
	%'Numpad1/Row1/6',
	%'Numpad1/Row0/7',
	%'Numpad1/Row0/8',
	%'Numpad1/Row0/9'
]
@onready var inputs2 = [
	%'Numpad2/Row3/0',
	%'Numpad2/Row2/1',
	%'Numpad2/Row2/2',
	%'Numpad2/Row2/3',
	%'Numpad2/Row1/4',
	%'Numpad2/Row1/5',
	%'Numpad2/Row1/6',
	%'Numpad2/Row0/7',
	%'Numpad2/Row0/8',
	%'Numpad2/Row0/9'
]

func _process(_delta: float) -> void:
	if xcollision(meteor, players[0]):
		Global.vs_winner = 2
		get_tree().change_scene_to_file.call_deferred("res://WinVS/WinVS.tscn")
	if xcollision(meteor, players[1]):
		Global.vs_winner = 1
		get_tree().change_scene_to_file.call_deferred("res://WinVS/WinVS.tscn")
	
	if !lasers: return
	for laser in lasers.get_children():
		if xcollision(meteor, laser):
			meteor.hit(laser)

var active_operations: Array[String]
func _ready():
	Global.game_mode = Global.GameModes.VS
	var ops: Dictionary[String, bool] = Preferences.saved.operations
	active_operations = ops.keys().filter(func(key): return ops[key])
	players[0].got_stunned.connect(new_op.bind(1))
	players[1].got_stunned.connect(new_op.bind(2))
	

	Global.time = 0
	Global.vs_op[0] = 0
	Global.vs_op[1] = 0
	for i in range(10):
		inputs1[i].connect('pressed', func(): _input_entered(1, i))
		inputs2[i].connect('pressed', func(): _input_entered(2, i))
	randomize()
	new_op(1)
	new_op(2)

func _input_entered(plyr: int, num: int):
	if players[plyr - 1].stunned: return
	if (num == answer1 and plyr == 1) or (num == answer2 and plyr == 2):
		players[plyr - 1].shoot()
		Preferences.remove_fail()
		Global.vs_op[plyr - 1] += 1
		new_op(plyr)
	else:
		players[plyr - 1].malfunct_shot()

var fails_pending: int
func new_op(plyr: int):
	players[plyr - 1].malfunction_count = 0
	if active_operations.is_empty():
		if plyr == 1:
			answer1 = int(NAN)
			%Operation1.text = "0 / 0 (:"
		else:
			answer2 = int(NAN)
			%Operation2.text = "0 / 0 (:"
		return
	if plyr == 1:
		var op1 = generate_operation(active_operations.pick_random())
		%Operation1.text = op1[3]
		answer1 = op1[2]
	if plyr == 2:
		var op2 = generate_operation(active_operations.pick_random())
		%Operation2.text = op2[3]
		answer2 = op2[2]

var mul_pairs = [
	[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8], [0, 9],
	[1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9],
	[2, 2], [2, 3], [2, 4], [3, 3],
	[2, 2], [2, 3], [2, 4], [3, 3],
	[2, 2], [2, 3], [2, 4], [3, 3],
	[2, 2], [2, 3], [2, 4], [3, 3],
]
func generate_operation(type: String):
	match type:
		"sum":
			var num1 = randi_range(0, 9)
			var num2 = randi_range(0, 9 - num1)
			var nums = [num1, num2]
			nums.shuffle()
			return [
				num1, num2,
				num1 + num2,
				"%d + %d" % nums
			]
		"sub":
			var num1 = randi_range(0, 9)
			var num2 = randi_range(0, 9)
			return [
				num1, num2,
				abs(num1 - num2),
				"%d − %d" % [max(num1, num2), min(num1, num2)]
			]
		"mul":
			var nums = mul_pairs.pick_random()
			nums.shuffle()
			var num1 = nums[0]
			var num2 = nums[1]
			return [
				num1, num2,
				num1 * num2,
				"%d × %d" % [num1, num2]
			]
		"div":
			var num2: int = randi_range(1, 9)
			var num1: int = (randi_range(0, 9) * num2)
			return [
				num1, num2,
				round(float(num1) / float(num2)),
				"%d ÷ %d" % [num1, num2]
			]



func timeout():
	Global.time += 1

func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://ModeSelection/ModeSelection.tscn")
