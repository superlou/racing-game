extends Node2D

@onready var label: Label = $Label


func _process(delta: float) -> void:
	label.text = "%.1f" % Engine.get_frames_per_second()
