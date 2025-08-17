extends Node3D


@onready var raycast: RayCast3D = $RayCast3D


@export var target_distance := 1.0

@export var kp := 100.0
@export var ki := 20.0
@export var kd := 40.0

var pid = PID.new()


func _ready():
	pid.set_coefficients(kp, ki, kd)
	pid.setpoint = 1.0


func calculate_force(delta:float) -> Vector3:
	if raycast.is_colliding():
		var point := raycast.get_collision_point()
		var distance := global_position.distance_to(point)
		var u := pid.run(distance, delta)
		return -raycast.target_position * u
	
	return Vector3.ZERO
