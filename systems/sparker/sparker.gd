extends Node3D

@onready var particles:GPUParticles3D = $GPUParticles3D
@onready var raycast:RayCast3D = $RayCast3D

func _process(delta: float) -> void:
	particles.emitting = raycast.is_colliding()
