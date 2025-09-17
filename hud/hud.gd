extends Control

@export var vehicle:Car
@export var race_manager:RaceManager
@onready var speed_label:Label = %Speed
@onready var current_lap:Label = $CurrentLap
@onready var elapsed_time:Label = $ElapsedTime
@onready var countdown:Label = $Countdown


func _process(_delta: float) -> void:
	speed_label.text = "%.0f" % vehicle.linear_velocity.length()
	current_lap.text = "Lap %d/%d" % [race_manager.car_statuses[vehicle].lap, race_manager.race_laps]
	elapsed_time.text = Humanize.elapsed_time_hh_ss(race_manager.elapsed_time)

	if race_manager.state == RaceManager.RaceState.COUNTDOWN:
		countdown.text = "%d" % ceilf(race_manager.countdown)
		countdown.show()
	else:
		countdown.hide()
