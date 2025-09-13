extends Node
class_name RaceManager

@export var cars:Array[Car] = []
@export var circuit:Circuit
@export var running := false
@export var elapsed_time := 0.0
@export var race_laps = 1

var car_statuses:Dictionary[Car, CarStatus] = {}


class CarStatus:
	var last_checkpoint:Checkpoint = null
	var lap := 1


func _ready() -> void:
	_build_car_statuses()
	_connect_checkpoint_signals()


func _process(delta: float) -> void:
	if running:
		elapsed_time += delta


func _build_car_statuses():
	for car in cars:
		car_statuses[car] = CarStatus.new()


func _connect_checkpoint_signals() -> void:
	var sequence := circuit.sequence
	for i in range(len(sequence.keys())):
		var key = sequence.keys()[i]
		var gate = get_parent().get_node(key)
		var checkpoint = gate.get_node("Checkpoint")
		checkpoint.car_entered.connect(func(car:Car): _on_car_entered(car, checkpoint))


func _on_car_entered(car:Car, checkpoint:Checkpoint) -> void:
	var status := car_statuses[car]

	var this_checkpoint_name := checkpoint.get_parent().name

	if status.last_checkpoint:
		var last_checkpoint_name := status.last_checkpoint.get_parent().name

		if circuit.checkpoints_connect(last_checkpoint_name, this_checkpoint_name):
			status.last_checkpoint = checkpoint
			print(this_checkpoint_name)
		
		if circuit.is_end_of_lap(this_checkpoint_name):
			status.lap += 1
	else:
		if circuit.is_first_checkpoint(this_checkpoint_name):
			status.last_checkpoint = checkpoint
			print("first")
	
	print(status.lap)
