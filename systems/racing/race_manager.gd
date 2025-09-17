extends Node
class_name RaceManager

enum RaceState {
	NEW,
	COUNTDOWN,
	RUNNING,
	FINISHED
}

@export var cars:Array[Car] = []
@export var circuit:Circuit
@export var state := RaceState.NEW
@export var countdown := 3.0
@export var elapsed_time := 0.0
@export var race_laps = 1

var car_statuses:Dictionary[Car, CarStatus] = {}


class CarStatus:
	var last_checkpoint:Checkpoint = null
	var lap := 1
	var is_finished := false
	var finish_time := 0.0
	var finish_place = 0


func _ready() -> void:
	_build_car_statuses()
	_connect_checkpoint_signals()


func _process(delta: float) -> void:
	if state == RaceState.RUNNING:
		elapsed_time += delta

	if state == RaceState.COUNTDOWN:
		countdown -= delta

		if countdown <= 0.0:
			countdown = 0.0
			state = RaceState.RUNNING


func _build_car_statuses():
	for car in cars:
		car_statuses[car] = CarStatus.new()


func _connect_checkpoint_signals() -> void:
	var sequence := circuit.sequence

	for i in range(len(sequence.keys())):
		var key = sequence.keys()[i]
		var checkpoint := Checkpoint.find_by_name(key)
		checkpoint.car_entered.connect(func(car:Car): _on_car_entered(car, checkpoint))


func _on_car_entered(car:Car, checkpoint:Checkpoint) -> void:
	var status := car_statuses[car]

	var this_checkpoint_name := checkpoint.name

	if status.last_checkpoint:
		var last_checkpoint_name := status.last_checkpoint.name

		if circuit.checkpoints_connect(last_checkpoint_name, this_checkpoint_name):
			status.last_checkpoint = checkpoint
			print(this_checkpoint_name)
		
		if circuit.is_end_of_lap(this_checkpoint_name):
			if status.lap < race_laps:
				status.lap += 1
			else:
				status.is_finished = true
				status.finish_time = elapsed_time
				# todo Determine the finished place based on car_statues that aren't finished
	else:
		if circuit.is_first_checkpoint(this_checkpoint_name):
			status.last_checkpoint = checkpoint
