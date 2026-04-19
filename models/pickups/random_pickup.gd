extends Pickup


func _on_entered(body: Node3D) -> void:
	print("picked up by ", body)
	activated.emit(body)
