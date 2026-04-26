extends Node3D


@export var duration := 30.0
@export var strength := 3.0

func _ready() -> void:
	await get_tree().create_timer(duration).timeout
	queue_free()
