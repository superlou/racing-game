@tool
extends Camera3D
class_name InterpolatedCamera

@export var lerp_speed = 5.0
@export var target:Node3D
@export var offset := Vector3.ZERO


func _physics_process(delta: float) -> void:
	if !target:
		return
	
	var target_transform = target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(
		target_transform,
		lerp_speed * get_process_delta_time()
	)
	look_at(target.global_transform.origin, target.transform.basis.y)
