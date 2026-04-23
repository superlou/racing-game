@tool
extends Control

@export var player_num: int :
	set(value):
		player_num = value
		for i in range(10, 21):
			%Camera.set_cull_mask_value(i, false)

		%Camera.set_cull_mask_value(player_num + 10, true)

@export var vehicle: Node3D :
	set(value):
		vehicle = value
		%Camera.target = vehicle
		%Hud.vehicle = vehicle
		vehicle.activated_pickup.connect(_on_activated_pickup)
		vehicle.item_slot_changed.connect(_on_item_slot_changed)

@export var race_manager: RaceManager :
	set(value):
		race_manager = value
		%Hud.race_manager = race_manager

var active_splash = null

func _on_activated_pickup(pickup: Pickup):
	if active_splash:
		active_splash.queue_free()

	var splash = pickup.splash.instantiate()
	splash.selected.connect(_on_pickup_item_selected)
	active_splash = splash
	add_child(splash)

func _on_pickup_item_selected(item: ItemData):
	active_splash = null
	vehicle.pick_up_item(item)

func _on_item_slot_changed(item: ItemData):
	if item:
		%ItemSlot.texture = item.icon
	else:
		%ItemSlot.texture = null
