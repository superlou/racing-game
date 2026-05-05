extends RigidBody3D


@onready var detonator: ShapeCast3D = $DetonatorShape
@onready var effect_area: Area3D = $EffectArea
@export var explosion_force := 1000.0


func _ready() -> void:
	rotation_degrees = Vector3(0, 180, 0)
	position = Vector3(0, 0, -1.0)
	reparent(get_tree().root)


func _physics_process(_delta: float) -> void:
	apply_central_force(global_basis * Vector3(0, 0, 100))

	if detonator.is_colliding():
		detonate()


func detonate():
	var bodies := effect_area.get_overlapping_bodies()
	for body in bodies:
		if body == self:
			continue

		if body is RigidBody3D:
			_toss_body(body)

	queue_free()


func _toss_body(body: RigidBody3D):
	var direction := body.global_position - effect_area.global_position
	var distance := direction.length()
	var explosion_radius: float = effect_area.get_child(0).shape.radius
	var force := explosion_force * (1.0 - distance / explosion_radius)
	body.apply_impulse(direction.normalized() * force, Vector3.ZERO)
