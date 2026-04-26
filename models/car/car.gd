extends RigidBody3D
class_name Car

signal speed_changed(speed:float)
signal activated_pickup(pickup: Pickup)

@export var thrust := 500.0
@export var turn_rate := 3.0
@export var roll_torque := 50
@export var pitch_torque := 50
@export var show_forces := false
@export var drag_scale := 1.0

var rotation_pid := PID.new()
var roll_pid := PID.new()
var counter_slide_pid := PID.new()
var num_active_tracons := 0

@onready var center_of_drag:Marker3D = $CenterOfDrag
@onready var player_input:PlayerInput = find_children("*", "PlayerInput").get(0)

var item_slot: ItemDef
signal item_slot_changed(item: ItemDef)

func _ready():
	rotation_pid.set_coefficients(100.0, 10.0, 1.0)
	roll_pid.set_coefficients(100.0, 10.0, 1.0)
	counter_slide_pid.set_coefficients(100.0, 10.0, 40.0)
	counter_slide_pid.setpoint = 0.0


func apply_tracons(_delta:float) -> void:
	num_active_tracons = 0

	for tracon in $Tracons.get_children():
		tracon.show_forces = show_forces

		if tracon.is_active():
			num_active_tracons += 1
			tracon.apply_force_to(self)


func apply_engine() -> void:
	if not player_input:
		return

	var engine_dir = ($EngineRay.global_basis * $EngineRay.target_position).normalized()
	apply_force(-thrust * engine_dir * player_input.accelerate)


func apply_drag(_delta:float) -> void:
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
	if not player_input:
		return

	rotation_pid.setpoint = turn_rate * player_input.turn

	# todo angular_velocity may not really be the right quantity since
	# it is a vector pointing in the axis of rotation where magnitude is
	# the angular velocity.
	var yaw_rate := (global_basis.inverse() * angular_velocity).y
	var rotation_torque = rotation_pid.run(yaw_rate, delta)
	apply_torque(global_basis * rotation_torque * Vector3.UP)


func apply_roll(_delta:float) -> void:
	if not player_input:
		return

	apply_torque(global_basis * roll_torque * -player_input.turn * Vector3.FORWARD)


func apply_pitch(_delta:float) -> void:
	if not player_input:
		return

	apply_torque(global_basis * pitch_torque * player_input.pitch * Vector3.RIGHT)


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
	if num_active_tracons > 0:
		apply_engine()
		apply_turn(delta)
	else:
		apply_pitch(delta)
		apply_roll(delta)

	apply_drag(delta)
	apply_lateral_stabilization(delta)


func _process(_delta: float) -> void:
	speed_changed.emit(linear_velocity.abs())


func pick_up_item(item: ItemDef) -> void:
	item_slot = item
	item_slot_changed.emit(item_slot)


func _unhandled_input(_event: InputEvent) -> void:
	if not player_input:
		return

	if player_input.use:
		activate_item_slot()


func activate_item_slot() -> void:
	if not item_slot:
		return

	if item_slot.active_scene:
		add_child(item_slot.active_scene.instantiate())

	item_slot = null
	item_slot_changed.emit(item_slot)
