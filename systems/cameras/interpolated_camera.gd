@tool
extends Camera3D
class_name InterpolatedCamera

@export var lerp_speed = 5.0
@export var target:RigidBody3D
@export var offset := Vector3.ZERO
@export var look_at_offset := Vector3.ZERO

func _physics_process(_delta: float) -> void:
	if !target:
		return

	var up = target.transform.basis.y
	var target_transform = global_transform

	if target.linear_velocity.length() > 0.1:
		var norm_velocity := target.linear_velocity.normalized()
		target_transform = target.global_transform \
			.translated(-norm_velocity * offset.z) \
			.translated(up * offset.y)
	else:
		target_transform = target.global_transform.translated_local(offset)

	global_transform = global_transform.interpolate_with(
		target_transform,
		lerp_speed * get_process_delta_time()
	)

	var look_at_target = target.global_transform.origin + target.global_basis * look_at_offset
	look_at(look_at_target, up)
