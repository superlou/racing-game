class_name PID

@export var setpoint := 0.0
@export var kp := 0.0
@export var ki := 0.0
@export var kd := 0.0

var prev_error := 0.0
var error_acc := 0.0

func set_coefficients(kp_:float, ki_:float, kd_:float) -> void:
    kp = kp_
    ki = ki_
    kd = kd_

func reset() -> void:
    prev_error = 0.0
    error_acc = 0.0

func run(y:float, delta:float) -> float:
    var error := setpoint - y
    error_acc += error * delta
    var error_rate := (error - prev_error) / delta
    prev_error = error
    return kp * error + ki * error_acc + kd * error_rate