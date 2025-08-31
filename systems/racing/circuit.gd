extends Node
class_name Circuit

@export var checkpoints := []

var next_map:Dictionary = {
	$SimpleGate: [$SimpleGate2]
}
