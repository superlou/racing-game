extends Marker3D
class_name PositionLeader

@export var gain := 1.0
@export var offset := Vector3.ZERO
@export var debug := false
@onready var parent:RigidBody3D = get_parent()

func _process(delta: float) -> void:
	if debug:
		DebugDraw3D.draw_sphere(global_position)

func _physics_process(delta: float) -> void:
	position = gain * (parent.basis.inverse() * parent.linear_velocity) + offset
