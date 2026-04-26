extends Node
class_name PlayerInput

@export var input_prefix := ""
@export var input_map: PlayerInputMap
@export var race_manager:RaceManager

var accelerate := 0.0
var turn := 0.0
var roll := 0.0
var pitch := 0.0
var use := true


func _ready() -> void:
	process_priority = get_parent().process_priority - 1
	input_map.register_inputs(input_prefix)


func _check_bipolar_action_pressed(positive: String, negative: String) -> float:
	if Input.is_action_pressed(input_prefix + positive):
		return 1.0
	elif Input.is_action_pressed(input_prefix + negative):
		return -1.0
	else:
		return 0.0


func _process(_delta: float) -> void:
	if race_manager and race_manager.state in [RaceManager.RaceState.NEW, RaceManager.RaceState.COUNTDOWN]:
		accelerate = 0.0
		turn = 0.0
		return

	accelerate = _check_bipolar_action_pressed("thrust_forward", "thrust_reverse")
	turn = _check_bipolar_action_pressed("turn_left", "turn_right")
	pitch = _check_bipolar_action_pressed("pitch_up", "pitch_down")
	# roll = _check_bipolar_action_pressed("roll_right", "roll_left")


func _unhandled_input(_event: InputEvent) -> void:
	use = Input.is_action_just_pressed(input_prefix + "use")
