extends Area3D
class_name Checkpoint

signal car_entered(car:Car)


func _ready() -> void:
	add_to_group("checkpoint")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D):
	if body is Car:
		car_entered.emit(body)


static func find_by_name(checkpoint_name: String) -> Checkpoint:
	var checkpoints = Engine.get_main_loop().get_nodes_in_group("checkpoint")
	return checkpoints.filter(func(n): return n.name == checkpoint_name)[0] as Checkpoint