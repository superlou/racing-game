@tool
extends SubViewportContainer

@export var vehicle: Node3D :
	set(value):
		vehicle = value
		%Camera.target = vehicle
		%Hud.vehicle = vehicle

@export var race_manager: RaceManager :
	set(value):
		race_manager = value
		%Hud.race_manager = race_manager
