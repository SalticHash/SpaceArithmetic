extends Node
class_name Game

@onready var meteor: Meteor = $World/Meteor
@onready var player: Player = $World/Player
@onready var lasers: Node2D = $World/Lasersas
@onready var exit_position: float = 1240.0 - meteor.radius
#----------------Utility Functions----------------#

func eval(operation : String) -> int:
	var _d = expression.parse(operation)
	var result : int = expression.execute()
	return result

func xcollision(a: Node2D, b: Node2D) -> bool:
	if !a or !b: return false
	return abs(a.global_position.x - b.global_position.x) \
		 < abs(a.radius + b.radius)
#-------------------------------------------------#
var answer := 0
var expression := Expression.new()
var skips = 3

@onready var inputs = [
	$'UI/OperationPanel/Numpad/Row3/0',
	$'UI/OperationPanel/Numpad/Row2/1',
	$'UI/OperationPanel/Numpad/Row2/2',
	$'UI/OperationPanel/Numpad/Row2/3',
	$'UI/OperationPanel/Numpad/Row1/4',
	$'UI/OperationPanel/Numpad/Row1/5',
	$'UI/OperationPanel/Numpad/Row1/6',
	$'UI/OperationPanel/Numpad/Row0/7',
	$'UI/OperationPanel/Numpad/Row0/8',
	$'UI/OperationPanel/Numpad/Row0/9'
]

func _process(_delta: float) -> void:
	if meteor.global_position.x > exit_position:
		get_tree().change_scene_to_file("res://Win/Win.tscn")
	if xcollision(meteor, player):
		get_tree().change_scene_to_file("res://Lose/Lose.tscn")
	if !lasers: return
	for laser in lasers.get_children():
		if xcollision(meteor, laser):
			meteor.hit(laser)
	for i in range(10):
		if Input.is_key_pressed(KEY_0 + i):
			_input_entered(i)
var active_operations: Array[String]
func _ready():
	var ops: Dictionary[String, bool] = Preferences.saved.operations
	active_operations = ops.keys().filter(func(key): return ops[key])
	
	$UI/Skip.text = tr("game_button_skips") % 3
	Global.time = 0
	Global.op = 0
	for i in range(10):
		inputs[i].connect('pressed', func(): _input_entered(i))
	randomize()
	new_op()

func _input_entered(num):
	if num == answer:
		$World/Player.shoot()
		Global.op += 1
		new_op()

func new_op():
	if active_operations.is_empty():
		answer = int(NAN)
		$UI/OperationPanel/Operation.text = "0 / 0 (:"
		return
	var op = generate_operation(active_operations.pick_random())
	$UI/OperationPanel/Operation.text = op[3]
	answer = op[2]

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
				"%d - %d" % [max(num1, num2), min(num1, num2)]
			]
		"mul":
			var nums = mul_pairs.pick_random()
			nums.shuffle()
			var num1 = nums[0]
			var num2 = nums[1]
			return [
				num1, num2,
				num1 * num2,
				"%d * %d" % [num1, num2]
			]
		"div":
			var num2: int = randi_range(1, 9)
			var num1: int = (randi_range(0, 9) * num2)
			return [
				num1, num2,
				round(float(num1) / float(num2)),
				"%d / %d" % [num1, num2]
			]



func Skip_pressed():
	if skips < 1:
		$UI/Skip.disabled = true
		return
	skips -= 1
	new_op()
	if skips < 1:
		$UI/Skip.disabled = true
	$UI/Skip.text = tr("game_button_skips") % skips

func timeout():
	Global.time += 1
