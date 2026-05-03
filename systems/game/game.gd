@tool
extends Node

@onready var view_grid: GridContainer = $ViewGrid
@onready var race_manager: RaceManager = $RaceManager
var PlayerViewScene = preload("res://systems/game/PlayerView.tscn")

@export_range(1, 9) var num_players := 1 :
	set(value):
		num_players = value
		if view_grid:
			_build_player_views()


func _build_player_views():
	for child in view_grid.get_children():
		child.queue_free()

	await get_tree().process_frame

	view_grid.columns = [1, 1, 2, 2, 3, 3, 3, 3, 3][num_players - 1]

	for i in range(num_players):
		var player_view: PlayerView = PlayerViewScene.instantiate()
		var player_num := i + 1
		player_view.name = "PlayerView%d" % player_num
		var player_car: Car = get_node("Car%d" % player_num)
		player_view.player_num = player_num
		player_view.race_manager = race_manager
		player_view.vehicle = player_car

		view_grid.add_child(player_view)
		player_view.owner = get_tree().edited_scene_root
