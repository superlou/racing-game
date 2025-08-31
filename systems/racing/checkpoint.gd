extends Area3D
class_name Checkpoint

signal car_entered(car:Car)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D):
	if body is Car:
		car_entered.emit(body)
