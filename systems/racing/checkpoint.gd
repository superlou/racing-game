extends Area3D
class_name Checkpoint


func _process(delta: float) -> void:
	print(get_overlapping_bodies())
