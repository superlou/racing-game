extends Node
class_name PlayerInput

@export var input_prefix := ""
@export var race_manager:RaceManager

var accelerate := 0.0
var turn := 0.0


func _ready() -> void:
	process_priority = get_parent().process_priority - 1


func _process(_delta: float) -> void:
	if race_manager and race_manager.state in [RaceManager.RaceState.NEW, RaceManager.RaceState.COUNTDOWN]:
		accelerate = 0.0
		turn = 0.0
		return

	if Input.is_action_pressed(input_prefix + "thrust_forward"):
		accelerate = 1.0
	elif Input.is_action_pressed(input_prefix + "thrust_reverse"):
		accelerate = -1.0
	else:
		accelerate = 0.0
	
	if Input.is_action_pressed(input_prefix + "turn_left"):
		turn = 1.0
	elif Input.is_action_pressed(input_prefix + "turn_right"):
		turn = -1.0
	else:
		turn = 0.0