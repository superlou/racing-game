extends Control

@export var vehicle:Car
@export var race_manager:RaceManager
@onready var speed_label:Label = %Speed
@onready var current_lap:Label = $CurrentLap
@onready var elapsed_time:Label = $ElapsedTime
@onready var countdown:Label = $Countdown
@onready var finished:Label = $Finished


func _process(_delta: float) -> void:
	speed_label.text = "%.0f" % vehicle.linear_velocity.length()
	current_lap.text = "Lap %d/%d" % [race_manager.car_statuses[vehicle].lap, race_manager.race_laps]

	if race_manager.state == RaceManager.RaceState.COUNTDOWN:
		countdown.text = "%d" % ceilf(race_manager.countdown)
		countdown.show()
	else:
		countdown.hide()

	var car_status := race_manager.car_statuses[vehicle]

	if car_status.is_finished:
		finished.show()
		elapsed_time.text = Humanize.elapsed_time_hh_ss(car_status.finish_time)
	else:
		finished.hide()
		elapsed_time.text = Humanize.elapsed_time_hh_ss(race_manager.elapsed_time)
