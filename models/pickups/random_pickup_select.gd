extends Control

@export var start_speed := 3.5
var current_speed := start_speed
var current_item = Items.pick_random()
var current_item_remaining_time := 1.0 / start_speed

signal selected(item: ItemDef)

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	current_item_remaining_time -= delta * current_speed
	if current_item_remaining_time < 0.0:
		current_item = Items.pick_next(current_item)
		current_item_remaining_time = 1.0 / start_speed

	if current_speed > 0.0:
		current_speed = maxf(current_speed - 2 * delta, 0.0)
	else:
		await get_tree().create_timer(0.5).timeout
		selected.emit(current_item)
		queue_free()

	%TextureRect.texture = current_item.icon
