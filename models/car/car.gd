extends RigidBody3D

@export var thrust := 400.0
@export var turn_rate := 3.0
@export var show_forces := false

var rotation_pid := PID.new()
var counter_slide_pid := PID.new()


func _ready():
	rotation_pid.set_coefficients(40.0, 0.0, 1.0)
	counter_slide_pid.set_coefficients(100.0, 0.0, 40.0)
	counter_slide_pid.setpoint = 0.0


func _physics_process(delta: float) -> void:
	for tracon in $Tracons.get_children():
		var force: Vector3 = tracon.calculate_force(delta)
		
		apply_force(force, basis * tracon.position)
		
		if show_forces:
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
		rotation_pid.setpoint = turn_rate
	elif Input.is_action_pressed("turn_right"):
		rotation_pid.setpoint = -turn_rate
	else:
		rotation_pid.setpoint = 0.0

	var rotation_torque = rotation_pid.run(angular_velocity.y, delta)
	apply_torque(rotation_torque * Vector3.UP)

	var lateral_velocity := (global_transform.basis.inverse() * linear_velocity).x
	var counter_slide_force := counter_slide_pid.run(lateral_velocity, delta)
	apply_central_force(basis * counter_slide_force * Vector3.RIGHT)
