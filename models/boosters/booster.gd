@tool
extends Node3D

@onready var area3d:Area3D = $Area3D
@onready var collision_shape:CollisionShape3D = $Area3D/CollisionShape3D
@onready var mesh_instance:MeshInstance3D = $MeshInstance3D

@export var width := 1.0 :
	set(value):
		width = value
		_update_dimensions()
@export var length := 1.0 :
	set(value):
		length = value
		_update_dimensions()
@export var height := 1.0 :
	set(value):
		height = value
		_update_dimensions()


func _ready() -> void:
	_update_dimensions()


func _physics_process(delta: float) -> void:
	if not area3d.has_overlapping_bodies():
		return
	
	for body in area3d.get_overlapping_bodies():
		body.apply_central_force(1000.0 * (global_basis * Vector3.FORWARD))


func _update_dimensions():
	if not mesh_instance:
		return 

	mesh_instance.mesh.size = Vector2(width, length)
	collision_shape.position.y = height / 2.0
	collision_shape.shape.size = Vector3(width, height, length)
