@abstract
extends Area3D
class_name Pickup


signal activated(by: Node3D)


func _ready() -> void:
	collision_mask = 2
	body_entered.connect(_on_entered)


@abstract func _on_entered(body: Node3D) -> void
