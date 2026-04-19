@tool
extends Node3D
class_name PickupSpawn

var pickup:Pickup = null

enum PickupType {
	RANDOM
}
@export var pickup_type := PickupType.RANDOM
var pickup_type_map = {
	PickupType.RANDOM: preload("res://models/pickups/RandomPickup.tscn")
}

func _ready() -> void:
	_spawn_pickup()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		DebugDraw3D.draw_sphere(global_position)
		DebugDraw3D.draw_text(global_position, "Pickup\nSpawn", 128)


func _spawn_pickup() -> void:
	pickup = pickup_type_map[pickup_type].instantiate()
	add_child(pickup)
	pickup.global_position = global_position
	pickup.activated.connect(_pickup_activated)


func _pickup_activated(picker: Node3D) -> void:
	pickup.queue_free()
	await get_tree().create_timer(3.0).timeout
	_spawn_pickup()
