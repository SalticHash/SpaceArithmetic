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

func _ready():
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
	var op = generate_operation(randi_range(0, 3))
	$UI/OperationPanel/Operation.text = op[3]
	answer = op[2]

func generate_operation(type: int):
	var num1 = randi_range(0, 9)
	var num2 = randi_range(0, 9)
	var answear := 0
	var optext := ''
	match type:
		0: # +
			optext = str(num1) + '+' + str(num2)
		1: # -
			optext = str(max(num1, num2)) + '-' + str(min(num1, num2))
		2: # *
			optext = str(num1) + '*' + str(num2)
		3: # /
			var op = generate_operation(2)
			optext = str(op[2]) + '/' + str(op[1])
	answear = eval(optext)
	if answear < 10:
		return [num1, num2, answear, optext]
	else:
		return generate_operation(type)


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
