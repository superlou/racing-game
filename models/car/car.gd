extends RigidBody3D

@export var thrust := 400.0
@export var torque := 50.0


func _physics_process(delta: float) -> void:
	for tracon in $Tracons.get_children():
		var force: Vector3 = tracon.calculate_force(delta)
		
		apply_force(force, tracon.position)
		print(tracon.position)
		
		DebugDraw3D.draw_arrow(
			tracon.global_position,
			tracon.global_position + force / 100.0,
			Color.WHITE,
			0.02
		)

	var engine_dir = $EngineRay.global_transform.basis * $EngineRay.target_position
	engine_dir = engine_dir.normalized()

	if Input.is_action_pressed("thrust_forward"):
		apply_force(-thrust * engine_dir)
	elif Input.is_action_pressed("thrust_reverse"):
		apply_force(thrust * engine_dir)

	if Input.is_action_pressed("turn_left"):
		apply_torque(torque * Vector3.UP)
	elif Input.is_action_pressed("turn_right"):
		apply_torque(torque * Vector3.DOWN)
