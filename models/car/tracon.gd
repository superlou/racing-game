extends Node3D


@onready var raycast: RayCast3D = $RayCast3D
@onready var no_collide_timer: Timer = $NoCollideTimer

@export var target_distance := 1.0:
	get:
		return target_distance
	set(value):
		target_distance = value
		pid.setpoint = target_distance

@export var kp := 400.0
@export var ki := 400.0
@export var kd := 150.0

var pid = PID.new()

@export var show_forces := false
var global_force := Vector3.ZERO

func _ready():
	pid.set_coefficients(kp, ki, kd)
	pid.setpoint = target_distance


func calculate_global_force(delta:float) -> Vector3:
	if raycast.is_colliding():
		if no_collide_timer.time_left > 0.0:
			return Vector3.ZERO

		var point := raycast.get_collision_point()
		var distance := global_position.distance_to(point)
		var u := pid.run(distance, delta)
		var raycast_direction = (global_basis * raycast.target_position).normalized()
		return -raycast_direction * u
	else:
		no_collide_timer.start()

	return Vector3.ZERO


func apply_force_to(body: RigidBody3D):
	body.apply_force(global_force, body.global_basis * position)


func _process(delta:float) -> void:
	global_force = calculate_global_force(delta)

	var fx = get_node("TraconFX")
	fx.intensity = clampf(global_force.length() / 250.0, 0.0, 1.0)

	if show_forces:
		_draw_debug()

func _draw_debug() -> void:
	DebugDraw3D.draw_arrow(global_position,	global_position + global_force / 10.0, Color.WHITE, 0.02)

func is_active() -> bool:
	return global_force.length() > 0.0
