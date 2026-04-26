extends Node


var db: Dictionary[String, ItemData] = {
	"boost": preload("res://models/items/boost.tres"),
	"shield": preload("res://models/items/shield.tres"),
	# "rocket": preload("res://models/items/rocket.tres"),
}

func pick_first() -> ItemData:
	return db[db.keys()[0]]


func pick_next(current: ItemData) -> ItemData:
	var current_key_index := db.values().find(current)
	var next_key_index := (current_key_index + 1) % db.size()
	return db[db.keys()[next_key_index]]

func pick_random() -> ItemData:
	var key = db.keys().pick_random()
	return db[key]
