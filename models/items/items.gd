extends Node


var db: Dictionary[String, ItemDef] = {
	"boost": preload("res://models/items/boost/boost_def.tres"),
	"shield": preload("res://models/items/shield/shield_def.tres"),
	"rocket": preload("res://models/items/rocket/rocket_def.tres"),
}

func pick_first() -> ItemDef:
	return db[db.keys()[0]]


func pick_next(current: ItemDef) -> ItemDef:
	var current_key_index := db.values().find(current)
	var next_key_index := (current_key_index + 1) % db.size()
	return db[db.keys()[next_key_index]]

func pick_random() -> ItemDef:
	var key = db.keys().pick_random()
	return db[key]
