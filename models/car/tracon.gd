extends Node3D


@onready var raycast: RayCast3D = $RayCast3D
@onready var no_collide_timer: Timer = $NoCollideTimer

@export var target_distance := 1.0

@export var kp := 600.0
@export var ki := 50.0
@export var kd := 50.0

var pid = PID.new()


func _ready():
	pid.set_coefficients(kp, ki, kd)
	pid.setpoint = 1.0


func calculate_force(delta:float) -> Vector3:
	if raycast.is_colliding():
		if no_collide_timer.time_left > 0.0:
			return Vector3.ZERO

		var point := raycast.get_collision_point()
		var distance := global_position.distance_to(point)
		var u := pid.run(distance, delta)
		
		return -raycast.target_position.normalized() * u
	else:
		no_collide_timer.start()
	
	return Vector3.ZERO
