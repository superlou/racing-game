extends RigidBody3D
class_name Car

signal speed_changed(speed:float)

@export var thrust := 500.0
@export var turn_rate := 3.0
@export var show_forces := false
@export var drag_scale := 1.0

var rotation_pid := PID.new()
var counter_slide_pid := PID.new()
var num_active_tracons := 0

@onready var center_of_drag:Marker3D = $CenterOfDrag


func _ready():
	rotation_pid.set_coefficients(100.0, 10.0, 1.0)
	counter_slide_pid.set_coefficients(200.0, 10.0, 40.0)
	counter_slide_pid.setpoint = 0.0


func apply_tracons(delta:float) -> void:
	num_active_tracons = 0

	for tracon in $Tracons.get_children():
		var force: Vector3 = tracon.calculate_global_force(delta)
		if force.length() > 0.0:
			num_active_tracons += 1
		
		apply_force(force, global_basis * tracon.position)
		
		if show_forces:
			DebugDraw3D.draw_arrow(
				tracon.global_position,
				tracon.global_position + force / 100.0,
				Color.WHITE,
				0.02
			)


func apply_engine() -> void:
	var engine_dir = ($EngineRay.global_basis * $EngineRay.target_position).normalized()

	if Input.is_action_pressed("thrust_forward"):
		apply_force(-thrust * engine_dir)
	elif Input.is_action_pressed("thrust_reverse"):
		apply_force(thrust * engine_dir)


func apply_drag(delta:float) -> void:
	var velocity := linear_velocity
	var drag := 0.5 * drag_scale * velocity.length() ** 2
	var drag_vector := drag * -velocity.normalized()
	apply_force(drag_vector, global_basis * center_of_drag.position)

	if show_forces:
		DebugDraw3D.draw_arrow(
			center_of_drag.global_position,
			center_of_drag.global_position + drag_vector / 200.0,
			Color.RED,
			0.02
		)


func apply_turn(delta:float) -> void:
	if Input.is_action_pressed("turn_left"):
		rotation_pid.setpoint = turn_rate
	elif Input.is_action_pressed("turn_right"):
		rotation_pid.setpoint = -turn_rate
	else:
		rotation_pid.setpoint = 0.0

	var yaw_rate := (global_basis.inverse() * angular_velocity).y
	var rotation_torque = rotation_pid.run(yaw_rate, delta)
	print(rotation_torque)
	apply_torque(global_basis * rotation_torque * Vector3.UP)


func apply_lateral_stabilization(delta:float) -> void:
	var lateral_velocity := (global_basis.inverse() * linear_velocity).x
	var counter_slide := counter_slide_pid.run(lateral_velocity, delta)

	var counter_slide_vector := Vector3.ZERO
	if num_active_tracons >= 2:
		counter_slide_vector = global_basis * counter_slide * Vector3.RIGHT	

	apply_force(counter_slide_vector)

	if show_forces:
		DebugDraw3D.draw_arrow(
			global_position,
			global_position + counter_slide_vector / 200.0,
			Color.BLUE,
			0.02
		)


func _physics_process(delta:float) -> void:
	apply_tracons(delta)
	apply_engine()
	apply_turn(delta)
	apply_drag(delta)
	apply_lateral_stabilization(delta)


func _process(delta: float) -> void:
	speed_changed.emit(linear_velocity.abs())
