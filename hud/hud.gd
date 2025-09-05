extends Node2D

@export var vehicle:Car
@export var race_manager:RaceManager
@onready var speed_label:Label = $Speed
@onready var current_lap:Label = $CurrentLap

func _process(delta: float) -> void:
	speed_label.text = "%.0f" % vehicle.linear_velocity.length()
	current_lap.text = "Lap %d" % race_manager.car_statuses[vehicle].lap