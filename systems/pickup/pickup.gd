@abstract
extends Area3D
class_name Pickup


signal activated(by: Node3D)
var splash: Resource = null

func _ready() -> void:
	collision_mask = 2
	body_entered.connect(_on_entered)


func _on_entered(body: Node3D) -> void:
	activated.emit(body)

	if body.has_signal("activated_pickup"):
		body.activated_pickup.emit(self)
