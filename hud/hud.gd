extends Node2D

@export var vehicle: Car
@onready var speed_label:Label = $Speed 

func _process(delta: float) -> void:
	speed_label.text = "%.0f" % vehicle.linear_velocity.length()
