extends Node3D


@onready var raycast: RayCast3D = $RayCast3D


@export var target_distance := 1.0

@export var kp := 300.0
@export var ki := 20.0
@export var kd := 50.0


var prev_error := 0.0
var error_acc := 0.0


func calculate_force(delta: float) -> Vector3:
	var dt := delta

	if raycast.is_colliding():
		var point := raycast.get_collision_point()
		var distance := global_position.distance_to(point)
		var error := target_distance - distance
		error_acc += error * dt
		var error_rate := (error - prev_error) / dt

		var u := kp * error + ki * error_acc + kd * error_rate

		prev_error = error;

		return -raycast.target_position * u
	
	return Vector3.ZERO
