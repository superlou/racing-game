extends Node

@export var duration := 3.0
@export var force := 1000.0


func _ready() -> void:
	await get_tree().create_timer(duration).timeout
	queue_free()

func _physics_process(_delta: float) -> void:
	var parent: RigidBody3D = get_parent()
	parent.apply_force(force * (parent.global_basis * Vector3.FORWARD))
