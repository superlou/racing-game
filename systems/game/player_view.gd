@tool
extends Control
class_name PlayerView

@export var player_num: int = 0

@export var vehicle: Node3D :
	set(value):
		vehicle = value
		%Camera.target = vehicle
		%Hud.vehicle = vehicle
		if vehicle:
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

func _on_pickup_item_selected(item: ItemDef):
	active_splash = null
	vehicle.pick_up_item(item)

func _on_item_slot_changed(item: ItemDef):
	if item:
		%ItemSlot.texture = item.icon
	else:
		%ItemSlot.texture = null
