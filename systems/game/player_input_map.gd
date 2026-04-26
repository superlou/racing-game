extends Resource
class_name PlayerInputMap

@export var thrust_forward: InputEvent
@export var thrust_reverse: InputEvent
@export var pitch_up: InputEvent
@export var pitch_down: InputEvent
@export var turn_left: InputEvent
@export var turn_right: InputEvent
@export var roll_left: InputEvent
@export var roll_right: InputEvent
@export var use: InputEvent


func register_inputs(prefix: String) -> void:
	for input_event in get_property_list().filter(
		func(x): return x.class_name == "InputEvent"
	):
		var global_action_name: String = prefix + input_event.name
		InputMap.add_action(global_action_name)
		InputMap.action_add_event(global_action_name, get(input_event.name))
